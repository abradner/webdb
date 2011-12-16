module ImportJobsHelper

  def get_time_left(import_job)
    if import_job.started_process_at.present? and
        import_job.total_count > 0 and 
        import_job.current_count > 0
      time_taken = import_job.updated_at - import_job.started_process_at
      current_count = import_job.current_count
      rows_left = import_job.total_count - current_count
      distance_of_time_in_words(import_job.started_process_at, import_job.started_process_at + (time_taken / current_count * rows_left).seconds) << " remaining"
    end
  end
end
