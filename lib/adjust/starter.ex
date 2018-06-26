defmodule Adjust.Starter do


def insert_data() do
{:ok, _pid} = Postgrex.start_link(name: :adjust_app,pool: DBConnection.Poolboy,pool_size: 8,hostname: "localhost", username: "postgres", password: "postgres", database: "foo")


   1..1000000
      |> Stream.map(fn(num) -> [num,rem(num,3),rem(num,5)] end)
	  |> Stream.chunk(5000,5000,[])
	  |> Task.async_stream(fn(chunk) ->
	    
		Postgrex.transaction( :adjust_app,fn conn ->
		pg_copy = Postgrex.stream(conn, "COPY source(a,b,c) FROM STDIN",[])
			
	chunk
	|> Enum.map(fn[a,b,c] -> [to_string(a), ?\t, to_string(b), ?\t, to_string(c), ?\n]	end)
    |> Enum.into(pg_copy)  
	
		 end, pool: DBConnection.Poolboy,pool_timeout: :infinity,timeout: :infinity)
		 
		end,max_concurrency: 8,timeout: :infinity)
	   |> Stream.run
	   
	  


end

def transfer_data() do
    get_data_from_foo()
end


def get_data_from_foo() do
{:ok, pid1} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "foo")

 Postgrex.transaction(pid1,fn conn ->
    Postgrex.stream(conn, "COPY source TO STDOUT", [])
	      |> Enum.map(fn(%Postgrex.Result{rows: rows}) -> rows end)
		  |> insert_into_bar()
		
		end,timeout: :infinity)

end

def insert_into_bar(data) do

{:ok, pid2} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "bar")

	 Postgrex.transaction(pid2, fn(conn) ->
       stream = Postgrex.stream(conn, "COPY dest(a,b,c) FROM STDIN", [])
        Enum.into(data, stream)
		
     end,timeout: :infinity)

end

end