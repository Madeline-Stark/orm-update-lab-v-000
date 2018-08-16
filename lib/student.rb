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
          @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
  end

  def self.create(name, grade)
   students = Student.new(name, grade)
   students.save
   students
 end

 def self.new_from_db(row)
    new_student = self.create(row[1], row[2])
    new_student
  end

 #  def self.find(id, db)
 #   found = db.execute("SELECT * FROM pokemon WHERE id = ?", id) #can't interpolate in sql
 #   lost = []
 #   lost = found.flatten
 #   Pokemon.new(id: lost[0], name: lost[1], type: lost[2], db: db) #need to be key value pairs
 # end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM songs
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row| #by using name as second argument, it’s replacing the ? in where and only returning those values
        self.new_from_db(row)
    end.first #chaining .first to return first element of the returned array
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
