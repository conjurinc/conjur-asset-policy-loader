#
# Copyright (C) 2016 Conjur Inc
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

class Conjur::Command::PolicyLoaders < Conjur::Command
  desc "Server side policy management"

  command :"policy-loader" do |cgrp|
    cgrp.desc "Load new policy updates (optionally, as a dry run)"
    cgrp.arg "repository-id"
    cgrp.command "load" do |c|
      c.arg_name "mode"
      c.desc "Policy loading mode, which may be 'load' or 'dry-run'"
      c.default_value "load"
      c.flag [:m, :mode]

      c.desc "Whether to follow the command output"
      c.default_value false
      c.switch [ :f, :follow ]
        
      c.action do |global_options,options,args|
        repository_id = require_arg(args, 'REPOSITORY-ID')
        raise "Receive extra command arguments" unless args.empty?
        
        job = api.create_policy_loader_job repository_id, options
        puts job.id
        if options[:follow]
          job.follow_output do |event|
            puts [ event.name, event.data ].join(" : ")
          end
        end
      end
    end
    
    cgrp.desc "Prints and follows the command output of a specific job"
    cgrp.arg "job-id"
    cgrp.command "output" do |c|
      c.action do |global_options,options,args|
        id = require_arg(args, 'JOB-ID')
        raise "Receive extra command arguments" unless args.empty?

        job = api.policy_loader_job id
        job.follow_output do |event|
          puts [ event.name, event.data ].join(" : ")
        end
      end
    end
  end
end
