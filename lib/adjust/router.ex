defmodule Adjust.Router do
  use Plug.Router

 plug Plug.Logger
  plug :match
  plug :dispatch
  
  get "/dbs/:which/tables/:whichtable" do
  
  
    
  {:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: which)
  
  
   Postgrex.transaction(pid,fn co ->
    dbquery = "SELECT a,b,c FROM #{inspect whichtable} ORDER BY a ASC"
		
		   
    %Postgrex.Result{rows: result} = Postgrex.query!(co, dbquery,[])
	   
   conn = send_chunked(conn, 200)
   
    result
	|> Enum.reduce_while(conn, fn (chunk, conn) ->
	   res = chunk |> Enum.join(",") 
	   res =res<>"\n"
  case Plug.Conn.chunk(conn, res) do
    {:ok, conn} -> 
      {:cont, conn}
    {:error, :closed} ->
      {:halt, conn}
	  
  end
    
	
	end)
	     
	
		end,timeout: :infinity)
		
		conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "BYE")
		
			
  end

  

  match _ do
    catchall(conn)
  end
  
  
 
  defp catchall(conn) do    

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "ERROR")
  end
end