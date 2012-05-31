
require File.expand_path('../../test_helper', __FILE__)

class CategoriesRequiredTest < ActiveSupport::TestCase
  fixtures :projects, :users, :members, :member_roles, :roles,
           :trackers, :projects_trackers,
           :enabled_modules,
           :versions,
           :issue_statuses, :issue_categories, :issue_relations, :workflows,
           :enumerations,
           :issues,
           :custom_fields, :custom_fields_projects, :custom_fields_trackers, :custom_values,
           :time_entries

  def test_category_required_when_module_enabled
    project = Project.find(1)
    project.enabled_module_names = [:categories_required]
    issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 2, :status_id => 1, :priority => IssuePriority.all.first, :subject => 'test_create', :description => 'IssueTest#test_category_required_when_module_enabled', :estimated_hours => '1:30')
    assert !issue.save
    issue.category = project.issue_categories.first
    assert issue.save
    issue.reload
    assert_equal 1.5, issue.estimated_hours
  end

  def test_category_not_required_when_module_disabled
    project = Project.find(1)
    issue = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => 2, :status_id => 1, :priority => IssuePriority.all.first, :subject => 'test_create', :description => 'IssueTest#test_category_required_when_module_enabled', :estimated_hours => '1:30')
    assert issue.save
    issue.reload
    assert_equal 1.5, issue.estimated_hours
  end
end
