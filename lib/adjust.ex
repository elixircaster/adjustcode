defmodule Adjust do
  use Application

 
  
  def start( _type, _args ) do
    Plug.Adapters.Cowboy.http(Adjust.Router, [],[port: 9001])
  end
end