require 'thread'

# Функція для обробки файлу (підрахунок кількості рядків у цьому прикладі)
def process_file(file_path)
  puts "Processing #{file_path} in thread #{Thread.current.object_id}"
  line_count = File.foreach(file_path).count
  puts "File #{file_path} has #{line_count} lines"
rescue => e
  puts "Error processing #{file_path}: #{e.message}"
end

# Основна програма
def process_files_in_directory(directory_path)
  # Перевіряємо, чи існує каталог
  unless Dir.exist?(directory_path)
    puts "Directory #{directory_path} does not exist"
    return
  end

  # Знаходимо всі файли в каталозі
  files = Dir.entries(directory_path).select { |f| File.file?(File.join(directory_path, f)) }

  if files.empty?
    puts "No files found in directory #{directory_path}"
    return
  end

  puts "Found #{files.size} files. Starting processing..."

  threads = []

  # Обробляємо файли в окремих потоках
  files.each do |file|
    threads << Thread.new do
      file_path = File.join(directory_path, file)
      process_file(file_path)
    end
  end

  # Очікуємо завершення всіх потоків
  threads.each(&:join)

  puts "All files processed"
end

# Виклик функції з вказівкою каталогу
directory_path = "./test_directory" # Замініть на ваш каталог
process_files_in_directory(directory_path)
