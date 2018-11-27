class PrepareMatrixController < ApplicationController

	def index
	end

	def generate_matrix
		size = params[:matrix]
		@@rows = size[:rows].to_i
		@@columns = size[:columns].to_i
		@@matrix = Array.new(@@rows) {Array.new(@@columns,0)}
		@@mat = Array.new(@@rows) {Array.new(@@columns,0)}
		@@total_mines = (@@rows*@@columns)/5
		@@safe_cells = (@@rows * @@columns) - @@total_mines 
      
       	@@first_click = true
        @demo = @@mat
	end
	def place_mines(p,q)
		count = 0
      	r = 0
      	c = 0
      
        while count < @@total_mines
        	if r >= @@rows
        		r = 0
        		c=0
        	end
        	pos = rand(2+(@@rows*@@columns)/@@total_mines)
        	if ((c+pos) < @@columns) && (r != p || (c+pos) != q)
        		c += pos
        		if @@matrix[r][c] >= 0
				   @@matrix[r][c] = -1
				   modify_cell_values(r,c)
				   count += 1
				end
				c = c+1
				
			else
				r = r+1
				c = 0
			end
        end
	end
	def modify_cell_values(r,c)
		
		i = r-1
		while i <= r+1
			j = c-1
			while j<= c+1
				if i>=0 && i<@@rows && j>=0 && j<@@columns
					if (i!=r || j!=c) && @@matrix[i][j] >= 0
						@@matrix[i][j] += 1
					end
				end
				j += 1
			end
			i += 1
		end
	end
	def update_matrix
		@opened_cells = []
		r = params[:row].to_i
		c = params[:col].to_i
		#byebug
		if @@first_click
		    place_mines(r,c)
			@@first_click = false
		end
		open_matrix(r,c)
		respond_to do |format|
			format.js {render json: @opened_cells}
		end

	end
	def open_matrix(r,c)
		if(@@mat[r][c] > -2)
			if @@matrix[r][c] < 0
				@opened_cells.push({id:"#{r},#{c}", value: -1})
			elsif @@matrix[r][c] == 0				
				@@safe_cells = @@safe_cells-1
				@opened_cells.push({:id => "#{r},#{c}", :value => @@matrix[r][c], :pending =>@@safe_cells})
				@@mat[r][c] = -2
				i = r-1
				while i <= (r+1)
					j = c-1
					while j <= (c+1)
						if i>=0 && i<@@rows && j>=0 && j<@@columns
							if (i!=r || j!=c) && @@matrix[i][j] >= 0
								if @@matrix[i][j] == 0
									open_matrix(i,j)
								else
								    if @@mat[i][j] > -2
								   		@@safe_cells = @@safe_cells-1
								   		@opened_cells.push({:id => "#{i},#{j}", :value => @@matrix[i][j], :pending =>@@safe_cells})
								    	@@mat[i][j] = -2
								   	end
								end
							end
						end
						j += 1
					end
					i += 1
				end
			else
				@@safe_cells = @@safe_cells-1
				@opened_cells.push({:id => "#{r},#{c}", :value => @@matrix[r][c], :pending =>@@safe_cells})
				@@mat[r][c] = -2
				
			end
		end
		return
		
	end
	
end
