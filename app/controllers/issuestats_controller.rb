class IssuestatsController < ApplicationController
  unloadable
  before_filter :find_project, :authorize

  def index
    @project = Project.find(params[:project_id])
    @issues = Issue.where(:project_id => @project.id)

    @status_ids = Array.new
    @issues.each do |issue|
      unless @status_ids.include?(issue.status_id)
         @status_ids << issue.status_id
      end
    end

    @options = Array.new
    @status_ids.each do |status_id|
      issue_status = IssueStatus.find_by_id(status_id)
      @options.push([issue_status.name, status_id])
    end

  end

  def show
    @start_date = Date.parse(params[:issuestats][:start_date])
    @end_date = Date.parse(params[:issuestats][:end_date])
    @intervention_status = params[:issuestats][:intervention_status]
    @intervention_statusname = IssueStatus.find_by_id(params[:issuestats][:intervention_status]).name
    @intervention_time = params[:issuestats][:intervention_time]
    @resolve_status = params[:issuestats][:resolve_status]
    @resolve_statusname = IssueStatus.find_by_id(params[:issuestats][:resolve_status]).name
    @resolve_time = params[:issuestats][:resolve_time]

    @project = Project.find(params[:project_id])
    @issues = Issue.where(:project_id => @project.id, :start_date => @start_date..@end_date)
    if @issues.length == 0
      flash[:error] = l(:issuestats_not_find)
      redirect_to project_issuestats_path(:project_id => @project.id)
    else
      @trackers = @project.rolled_up_trackers
      @priorities = IssuePriority.where(:active => true)

      @status_ids = Array.new
      @issues.each do |issue|
        unless @status_ids.include?(issue.status_id)
           @status_ids << issue.status_id
        end
      end
    end
  end

end
