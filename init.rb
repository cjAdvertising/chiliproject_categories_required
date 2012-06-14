require 'redmine'

Redmine::Plugin.register :chiliproject_categories_required do
  name 'Chiliproject Categories Required plugin'
  author 'cj Advertising, LLC'
  description 'Adds a project setting to enable required categories on new issues'
  version '0.0.1'
  url 'http://cjadvertising.com'
  author_url 'http://cjadvertising.com'

  # Enabling module for a project makes categories required
  project_module :categories_required do
    # Add fake perm or module won't show up
    permission :view_categories_required, nil => nil
  end
end

# Make category field required for issues when the module is enabled
require 'dispatcher'
Dispatcher.to_prepare :chiliproject_categories_required_patches do
  Issue.send(:validates_presence_of, :category, :if => Proc.new { |i| i.project.module_enabled?(:categories_required) && !i.project.issue_categories.empty? })
end