class AddNamespaceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
   ########### Controller ###########
   #/\n(\s*[^\s])/ => "\n  #{$1}"
   #"module name.camellize\n" (content) "\nend"
   #/redirect_to (@#{Regexp.quote(ressource_name)})/ => "redirect_to [:admin, #{$1}]"
   #/(?<!admin)(#{Regexp.quote(ressource_name)}_(url|path))/ => "admin_#{$1}"
   
   ########### Views ###########
   #/(?<!admin)(#{Regexp.quote(ressource_name)}_(url|path))/ => "admin_#{$1}"
   #/link_to ([^,]*,) (@?#{Regexp.quote(ressource_name)})(\W)/ => "link_to #{$1} [:admin, #{$2}]#{$3}"
end
