require_relative 'script'
class Launch < Script(__FILE__, __LINE__)

  attr_accessor :mode, :refresh_repo, :open_browser, :try, :max
  def config_ru; root/:config/"#{mode}.ru"; end
  
  # Install the options
  options do |opt|
    self.refresh_repo = true
    opt.on('-r', '--[no-]refresh', "Issues a 'git remote update' first?") do 
      self.refresh_repo = false
    end
    self.open_browser = true
    opt.on('-b', '--[no-]browser', "Open the browser automatically?") do 
      self.open_browser = false
    end
    self.try = 0
    self.max = 500
    opt.on('--max=MAX', Integer, "Number of connection attempts") do |value|
      self.max = Integer(value)
    end
  end
  
  # Tries to access the website
  def wait_and_open
    info "Attempting to connect to the web site..."
    Http.head "http://127.0.0.1:3000/"
  rescue Errno::ECONNREFUSED
    sleep(0.5)
    retry if (self.try += 1) < max
    info "Server not found, sorry."
    raise
  else
    Launchy.open("http://127.0.0.1:3000/")
  end
  
  def execute(argv)
    abort help unless argv.size <= 1
    self.mode = (argv.first || "development").to_sym
    abort "Invalid mode #{mode}" unless config_ru.exist?

    info "Refreshing repository info..." do
      Process.wait spawn("git remote update")
    end if refresh_repo

    thinpid = nil
    info "Starting the web server..." do
      thinpid = spawn("thin -R #{config_ru} start")
    end

    info "Waiting for the server to start" do
      require 'launchy'
      require 'http'
      wait_and_open
    end if open_browser

  rescue => ex
    info "Lauching failed: #{ex.message}"
    info ex.backtrace.join("\n")
    Process.kill("SIGHUP", thinpid) if thinpid
  ensure
    Process.wait(thinpid) if thinpid
  end

end
Launch.run(ARGV) if $0 == __FILE__
