require 'resque/tasks'
require 'resque/scheduler/tasks'

# Start a worker with proper env vars and output redirection
def run_worker(queue, count = 1)
  puts "Starting #{count} worker(s) with QUEUE: #{queue}"
  ops = {:pgroup => true, :err => [(Rails.root + 'log/resque_err').to_s, 'a'],
         :out => [(Rails.root + 'log/resque_stdout').to_s, 'a']}
  ops_s = {:pgroup => true, :err => [(Rails.root + 'log/resque_scheduler_err').to_s, 'a'],
           :out => [(Rails.root + 'log/resque_scheduler_stdout').to_s, 'a']}
  env_vars = {'QUEUES' => queue.to_s,
              'BACKGROUND' => 'yes',
              'TERM_CHILD' => '1'}
  count.times {
    ## Using Kernel.spawn and Process.detach because regular system() call would
    ## cause the processes to quit when capistrano finishes
    pid = spawn(env_vars, 'bundle exec rake resque:work', ops)
    Process.detach(pid)
    pid = spawn(env_vars, 'bundle exec rake resque:scheduler', ops_s)
    Process.detach(pid)
  }
end

namespace :resque do
  task :setup => :environment

  desc "Restart running workers"
  task :restart_workers => :environment do
    Rake::Task['resque:stop_workers'].invoke
    Rake::Task['resque:start_workers'].invoke
  end

  desc "Quit running workers"
  task :stop_workers => :environment do
    pids = Array.new
    Resque.workers.each do |worker|
      pids = pids | worker.worker_pids[0...-1]
    end
    if pids.empty?
      puts "No workers to kill"
    else
      syscmd = "kill -s QUIT #{pids.join(' ')}"
      puts "Running syscmd: #{syscmd}"
      begin
        system(syscmd)
      rescue => e
        puts "Error: #{e}"
      end
    end
  end

  desc "Start workers"
  task :start_workers => :environment do
    run_worker("*")
    # run_worker("high")
  end

  task :setup_schedule => :setup do
    require 'resque-scheduler'

    Resque.schedule = YAML.load_file('config/resque_schedule.yml')

  end

  task :scheduler => :setup_schedule
end