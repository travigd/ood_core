module OodCore
  module Job
    # A class that handles the communication with a resource manager for
    # submitting/statusing/holding/deleting jobs
    # @abstract
    class Adapter
      using Refinements::ArrayExtensions

      # Submit a job with the attributes defined in the job template instance
      # @abstract Subclass is expected to implement {#submit}
      # @raise [NotImplementedError] if subclass did not define {#submit}
      # @example Submit job template to cluster
      #   solver_id = job_adapter.submit(solver_script)
      #   #=> "1234.server"
      # @example Submit job that depends on previous job
      #   post_id = job_adapter.submit(
      #     post_script,
      #     afterok: solver_id
      #   )
      #   #=> "1235.server"
      # @param script [Script] script object that describes the
      #   script and attributes for the submitted job
      # @param after [#to_s, Array<#to_s>] this job may be scheduled for execution
      #   at any point after dependent jobs have started execution
      # @param afterok [#to_s, Array<#to_s>] this job may be scheduled for
      #   execution only after dependent jobs have terminated with no errors
      # @param afternotok [#to_s, Array<#to_s>] this job may be scheduled for
      #   execution only after dependent jobs have terminated with errors
      # @param afterany [#to_s, Array<#to_s>] this job may be scheduled for
      #   execution after dependent jobs have terminated
      # @return [String] the job id returned after successfully submitting a job
      def submit(script, after: [], afterok: [], afternotok: [], afterany: [])
        raise NotImplementedError, "subclass did not define #submit"
      end

      # Retrieve info for all jobs from the resource manager
      # @abstract Subclass is expected to implement {#info_all}
      # @raise [NotImplementedError] if subclass did not define {#info_all}
      # @return [Array<Info>] information describing submitted jobs
      def info_all
        raise NotImplementedError, "subclass did not define #info_all"
      end

      # Retrieve info for all jobs for a given owner or owners from the
      # resource manager
      # @param owner [#to_s, Array<#to_s>] the owner(s) of the jobs
      # @return [Array<Info>] information describing submitted jobs
      def info_where_owner(owner)
        owner = Array.wrap(owner).map(&:to_s)
        info_all.select { |info| owner.include? info.job_owner }
      end

      # Retrieve job info from the resource manager
      # @abstract Subclass is expected to implement {#info}
      # @raise [NotImplementedError] if subclass did not define {#info}
      # @param id [#to_s] the id of the job
      # @return [Info] information describing submitted job
      def info(id)
        raise NotImplementedError, "subclass did not define #info"
      end

      # Retrieve job status from resource manager
      # @note Optimized slightly over retrieving complete job information from server
      # @abstract Subclass is expected to implement {#status}
      # @raise [NotImplementedError] if subclass did not define {#status}
      # @param id [#to_s] the id of the job
      # @return [Status] status of job
      def status(id)
        raise NotImplementedError, "subclass did not define #status"
      end

      # Put the submitted job on hold
      # @abstract Subclass is expected to implement {#hold}
      # @raise [NotImplementedError] if subclass did not define {#hold}
      # @param id [#to_s] the id of the job
      # @return [void]
      def hold(id)
        raise NotImplementedError, "subclass did not define #hold"
      end

      # Release the job that is on hold
      # @abstract Subclass is expected to implement {#release}
      # @raise [NotImplementedError] if subclass did not define {#release}
      # @param id [#to_s] the id of the job
      # @return [void]
      def release(id)
        raise NotImplementedError, "subclass did not define #release"
      end

      # Delete the submitted job
      # @abstract Subclass is expected to implement {#delete}
      # @raise [NotImplementedError] if subclass did not define {#delete}
      # @param id [#to_s] the id of the job
      # @return [void]
      def delete(id)
        raise NotImplementedError, "subclass did not define #delete"
      end
    end
  end
end
