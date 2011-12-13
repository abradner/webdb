class Notifier < ActionMailer::Base

  PREFIX = "WebDB - "

  def notify_user_of_approved_request(recipient)
    @user = recipient
    mail(:to => @user.email,
         :from => APP_CONFIG['account_request_user_status_email_sender'],
         :reply_to => APP_CONFIG['account_request_user_status_email_sender'],
         :subject => PREFIX + "Your access request has been approved")
  end

  def notify_user_of_rejected_request(recipient)
    @user = recipient
    mail(:to => @user.email,
         :from => APP_CONFIG['account_request_user_status_email_sender'],
         :reply_to => APP_CONFIG['account_request_user_status_email_sender'],
         :subject => PREFIX + "Your access request has been rejected")
  end

  # notifications for super users
  def notify_superusers_of_access_request(applicant)
    superusers_emails = User.get_superuser_emails
    @user = applicant
    mail(:to => superusers_emails,
         :from => APP_CONFIG['account_request_admin_notification_sender'],
         :reply_to => @user.email,
         :subject => PREFIX + "There has been a new access request")
  end

  def notify_user_that_they_cant_reset_their_password(user)
    @user = user
    mail(:to => @user.email,
         :from => APP_CONFIG['password_reset_email_sender'],
         :reply_to => APP_CONFIG['password_reset_email_sender'],
         :subject => PREFIX + "Reset password instructions")
  end

  def notify_user_of_import_validation_started(import_job)
    @import_job = import_job
    @user = import_job.user
    mail(:to => @user.email,
         :from => APP_CONFIG['import_job_sender'],
         :reply_to => APP_CONFIG['import_job_sender'],
         :subject => PREFIX + "Validation started on import job")

  end

  def notify_user_of_import_validation_ended(import_job, results)
    @import_job = import_job
    @user = import_job.user
    @results = results
    mail(:to => @user.email,
         :from => APP_CONFIG['import_job_sender'],
         :reply_to => APP_CONFIG['import_job_sender'],
         :subject => PREFIX + "Validation ended on import job")

  end

  def notify_user_of_import_started(import_job)
    @import_job = import_job
    @user = import_job.user
    mail(:to => @user.email,
         :from => APP_CONFIG['import_job_sender'],
         :reply_to => APP_CONFIG['import_job_sender'],
         :subject => PREFIX + "Import job started")

  end

  def notify_user_of_import_ended(import_job, results)
    @import_job = import_job
    @user = import_job.user
    @results = results

    mail(:to => @user.email,
         :from => APP_CONFIG['import_job_sender'],
         :reply_to => APP_CONFIG['import_job_sender'],
         :subject => PREFIX + "Import job completed")

  end

end
