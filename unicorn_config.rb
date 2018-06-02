# coding: utf-8
worker_processes 4
preload_app true
# listen "127.0.0.1:8080"
listen "/home/isucon/private_isu/webapp/ruby/tmp/unicorn_config.sock", backlog: 1024
@dir = "/home/isucon/private_isu/webapp/ruby/"

#worker_processes 2 # CPUのコア数に揃える
working_directory @dir

timeout 300

pid "#{@dir}tmp/pids/unicorn.pid" #pidを保存するファイル

# unicornは標準出力には何も吐かないのでログ出力を忘れずに
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"
