# We mark our plugin as reloadable to work around Rails bug #1339
# (http://rails.lighthouseapp.com/projects/8994/tickets/1339) which
# we might run into in development mode (e.g. when cache_classes ==
# true) when doing funky stuff with our AR models (such as using
# other plugins messing with them).
#
# Basically we need to make sure that everything AR-related is
# fully reloaded upon each request as AR undefs all Base subclasses'
# methods and removes any instance variables..
ActiveSupport::Dependencies.load_once_paths.delete lib_path unless Rails.configuration.cache_classes
