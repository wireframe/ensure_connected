# ensure that your database connection is valid before executing a method
# see http://gist.github.com/238999
# see http://axonflux.com/resque-to-the-rescue-but-a-gotcha-dont-forget
class Module
  def ensure_connected(method)
    define_method("#{method}_with_verified_connections") do |*args|
      ActiveRecord::Base.connection_handler.verify_active_connections!
      send("#{method}_without_verified_connections", *args)
    end
    alias_method_chain method, :verified_connections
  end
end
