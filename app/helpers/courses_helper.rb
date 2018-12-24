module CoursesHelper
  def course_filter_by_condition(courses, params, keys)
    if params == nil
      return courses
    end
    res = []
    courses.each do |course|
      ok = true
      keys.each do |key|
        if not (params[key] == '' or course[key] == params[key])
          ok = false
          break
        end
      end
      if ok
        res << course
      end
    end
    res
  end
  
  def get_course_info(courses, type, type2=nil)
    res = Set.new
    courses.each do |course|
      if type2
        res.add(course[type].to_s+'-'+course[type2].to_s)
      else
        res.add(course[type])
      end
    end
    res.to_a.sort
  end
  
  def week_data_to_num(week_data)
    param = {
        '周一' => 0,
        '周二' => 1,
        '周三' => 2,
        '周四' => 3,
        '周五' => 4,
        '周六' => 5,
        '周天' => 6,
    }
    param[week_data] + 1
  end

  def get_course_table(courses)
    course_time = Array.new(11) { Array.new(7, {'name' => '', 'id' => ''}) }
    if courses
      courses.each do |cur|
        cur_time = String(cur.course_time)
        end_j = cur_time.index('(')
        j = week_data_to_num(cur_time[0...end_j])
        t = cur_time[end_j + 1...cur_time.index(')')].split("-")
        for i in (t[0].to_i..t[1].to_i).each
          course_time[(i-1)*7/7][j-1] = {
            'name' => cur.name,
            'id' => cur.id
          }
        end
      end
    end
    course_time
  end
  
  def get_current_curriculum_table(courses,user)
    course_time = Array.new(11) {Array.new(7) {Array.new(3, '')}}
    courses.each do |cur|
      real_course_name = cur.name
      cur_time = String(cur.course_time)
      end_j = cur_time.index('(')#index第一次出现的字节位置 end_j=2
      j = week_data_to_num(cur_time[0...end_j])
      t = cur_time[end_j + 1...cur_time.index(')')].split("-")
      for i in (t[0].to_i..t[1].to_i).each
        course_time[(i-1)*7/7][j-1][0] = real_course_name
        course_time[(i-1)*7/7][j-1][1] = cur.course_week
        course_time[(i-1)*7/7][j-1][2] = cur.class_room
      end
    end
    course_time
  end
end
