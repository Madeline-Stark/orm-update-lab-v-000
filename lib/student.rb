require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
     sql = <<-SQL
     CREATE TABLE IF NOT EXISTS students (
     id INTEGER PRIMARY KEY,
     name TEXT,
     grade NUMBER
     )
     SQL
     DB[:conn].execute(sql)
 end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
        SQL
    DB[:conn].execute(sql)
  end

  # def save
  #   sql = <<-SQL
  #     INSERT INTO students (name, grade)
  #     VALUES (?, ?)
  #   SQL
  #
  #   DB[:conn].execute(sql, self.name, self.grade)
  #
  #     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0] #grabs id #
  #
  # end

  def save
      if self.id
        self.update
      else
          sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?, ?)
          SQL
          DB[:conn].execute(sql, self.name, self.grade)
          @id = DB[:conn].execute(“SELECT last_insert_rowid() FROM students”)[0][0]
      end
  end

  def self.create(name:, grade:)
   students = Student.new(name, grade)
   students.save
   students
 end

 def self.new_from_db(row)
    new_student = self.new #same as running Song.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
end

  def update
        sql = <<-SQL
        UPDATE students
        SET name = ?, grade = ?
        WHERE id = ?
        SQL
        DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
