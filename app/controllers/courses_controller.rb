class CoursesController < ApplicationController
  include CoursesHelper

  before_action :student_logged_in, only: [:select, :quit, :list]
  before_action :teacher_logged_in, only: [:new, :create, :edit, :destroy, :update, :open, :close, :student_list]#add open by qiao
  before_action :logged_in, only: :index

  #-------------------------for teachers----------------------

  def new
    @course=Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      current_user.teaching_courses<<@course
      redirect_to courses_path, flash: {success: "新课程申请成功"}
    else
      flash[:warning] = "信息填写有误,请重试"
      render 'new'
    end
  end

  def edit
    @course=Course.find_by_id(params[:id])
  end

  def update
    @course = Course.find_by_id(params[:id])
    if @course.update_attributes(course_params)
      flash={:info => "更新成功"}
    else
      flash={:warning => "更新失败"}
    end
    redirect_to courses_path, flash: flash
  end

  def open
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: true)
    redirect_to courses_path, flash: {:success => "已经成功开启该课程:#{ @course.name}"}
  end

  def close
    @course=Course.find_by_id(params[:id])
    @course.update_attributes(open: false)
    redirect_to courses_path, flash: {:success => "已经成功关闭该课程:#{ @course.name}"}
  end

  def destroy
    @course=Course.find_by_id(params[:id])
    current_user.teaching_courses.delete(@course)
    @course.destroy
    flash={:success => "成功删除课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end

  def student_list
    @course = Course.find_by_id(params[:id])
    @user = @course.users
    @user_department = {}
    @user.each do |user|
      if !@user_department.has_key?(user.department)
        @user_department[user.department] = 0
      end
      @user_department[user.department] += 1
    end
  end
  #-------------------------for students----------------------

  def list

    @courses = Course.where(:open=>true).paginate(page: params[:page], per_page: 4)
    @course = @current_user.courses

    # Yue's search code
    if params[:search]
      @course = Course.search(params[:search]).order("created_at DESC")
    elsif session[:search]
      @course = Course.search(session[:search]).order("created_at DESC")
    else
      @course = Course.all.order('created_at DESC')
    end
    search_record

    @course_to_choose = @course
    @course_time_table = get_course_table(@course_to_choose)
    @course_time = get_course_info(@course_to_choose, 'course_time')
    @course_exam_type = get_course_info(@course_to_choose, 'exam_type')
    
    @current_user_course=current_user.courses
    @user=current_user
    @course_credit = get_course_info(@course_to_choose, 'credit')
    
    if request.post?
      @course = course_filter_by_condition(@course_to_choose, params, ['course_time', 'exam_type'])
    end
    
  end

  def select
    @course=Course.find_by_id(params[:id])

    if course_conflict?(get_student_course(), @course)
      flash={:warning => "课程冲突"}
    else
      fails_course = []
      success_course = []
      course = @course
      if course.grades.length < course.limit_num and Grade.create(:user_id => current_user.id, :course_id => course.id)
        success_course << course.name
      else
        fails_course << course.name
      end

      if success_course.length !=0
        flash = {:success => ("成功选择课程:  " + success_course.join(','))}
      end
      if fails_course.length !=0
        waring_info = fails_course.join(',') +'  人数已满'
        if flash != nil
          flash[:warning] = waring_info
        else
          flash = {:warning => waring_info}
        end
      end
    end
    redirect_to courses_path, flash: flash
  end

  def quit
    @course=Course.find_by_id(params[:id])
    current_user.courses.delete(@course)
    flash={:success => "成功退选课程: #{@course.name}"}
    redirect_to courses_path, flash: flash
  end


  #-------------------------for both teachers and students----------------------

  def index
    @course=current_user.teaching_courses.paginate(page: params[:page], per_page: 4) if teacher_logged_in?
    @course=current_user.courses.paginate(page: params[:page], per_page: 4) if student_logged_in?


    @course_to_choose = @course
    @current_user_course=current_user.courses
    @user=current_user
    @course_credit = get_course_info(@course_to_choose, 'credit')

  end
  
  def timetable
    @course=current_user.courses
    @current_user_course=current_user.courses
    @user=current_user
    @course_time_table = get_current_curriculum_table(@course,@user)#当前课表
  end

  private

  # Confirms a student logged-in user.
  def student_logged_in
    unless student_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a teacher logged-in user.
  def teacher_logged_in
    unless teacher_logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  # Confirms a  logged-in user.
  def logged_in
    unless logged_in?
      redirect_to root_url, flash: {danger: '请登陆'}
    end
  end

  def course_params
    params.require(:course).permit(:course_code, :name, :course_type, :teaching_type, :exam_type,
                                   :credit, :limit_num, :class_room, :course_time, :course_week)
  end

end