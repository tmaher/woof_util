class WoofUtil

  # usage
  # shellout "xargs", :stdin => "/etc", :args => ["ls", "-ld"]
  def self.shellout(cmd, params = {})
    params[:stdin] ||= ""
    params[:args] ||= []
    
    parent_r,child_w=IO.pipe ; parent_r.binmode ; child_w.binmode
    child_r,parent_w=IO.pipe ; child_r.binmode ; parent_w.binmode

    pid = fork do
      parent_r.close
      parent_w.close
      $stdin.reopen child_r
      $stdout.reopen child_w
      $stderr.reopen child_w
      # should be closing other open FDs, punting on it for now
      exec *([cmd].concat params[:args])
    end
    child_w.close
    child_r.close
    buf = []
    parent_w.write params[:stdin]
    parent_w.close
    while Process.waitpid(pid, Process::WNOHANG).nil? do
      buf.push(parent_r.read 4096)
    end
    buf.push(parent_r.read 4096)
    parent_r.close
    buf.join
  end

  def self.hello
    "hello"
  end
  
end
