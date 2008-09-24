# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def section_link(name,options)
      if options[:action] == @current_action and options[:controller].ends_with?@current_controller
         link_to(name, options, :class => 'on')
      else
        link_to(name,options)
      end
  end
end
