require 'mysql2'

def config
  @config ||= {
    db: {
      # socket: '/var/run/mysqld/mysqld.sock',
      host: ENV['ISUCONP_DB_HOST'] || 'localhost',
      port: ENV['ISUCONP_DB_PORT'] && ENV['ISUCONP_DB_PORT'].to_i,
      username: ENV['ISUCONP_DB_USER'] || 'root',
      password: ENV['ISUCONP_DB_PASSWORD'],
      database: ENV['ISUCONP_DB_NAME'] || 'isuconp',
    },
  }
end

def db
  return Thread.current[:isuconp_db] if Thread.current[:isuconp_db]
  client = Mysql2::Client.new(
    host: config[:db][:host],
    port: config[:db][:port],
    username: config[:db][:username],
    password: config[:db][:password],
    database: config[:db][:database],
    encoding: 'utf8mb4',
    reconnect: true,
  )
  client.query_options.merge!(symbolize_keys: true, database_timezone: :local, application_timezone: :local)
  Thread.current[:isuconp_db] = client
  client
end

def ext mime
  if mime == 'image/jpeg'
    'jpg'
  elsif mime == 'image/png'
    'png'
  elsif mime == 'image/gif'
    'gif'
  else
    raise
  end
end

def main
  8.downto(1) {|i|
    query = <<SQL
    SELECT id, mime, imgdata
    FROM posts
    WHERE id <= #{i * 1000}
    ORDER BY created_at DESC
    LIMIT 1000
SQL
    print query
    results = db.query(query)
    results.each { |res|
      filename = "../public/image/#{res[:id]}.#{ext(res[:mime])}"
      puts filename
      File.open(filename, "wb") do |f|
        f.write res[:imgdata]
      end
    }
  }
end

main
