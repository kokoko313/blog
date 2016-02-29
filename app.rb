require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:lepro.db"

class Post < ActiveRecord::Base
	validates :username, presence: true, length: { in: 3..12 }
	validates :content, presence: true
	validates :created_date, presence: true
end

class Comment < ActiveRecord::Base
	validates :post_id, presence: true
	validates :content, presence: true
	validates :created_date, presence: true
end

get '/' do
	@posts = Post.order('created_at DESC')
	erb :index
end

get '/new' do
	@p = Post.new
  	erb :new
end

post '/new' do

	@p = Post.new params[:post]
	@p.created_date = Time.now
	if @p.save
		erb "<h2>Спасибо, вы добавили новый пост!</h2>"
	else
		@error = @p.errors.full_messages.first
		erb :new
	end

end

get '/details/:post_id' do

	post_id=params[:post_id]
	
	results = @db.execute 'select * from Posts where id = ?', [post_id]
	
	@row = results[0]

	@comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

	erb :details

end

post '/details/:post_id' do

	post_id=params[:post_id]
	content = params[:content]

	if content.length <= 0
	@error = 'Type comment text'
    redirect to ('/details/' + post_id)
  	end

	# сохранение данных в бд

	@db.execute 'insert into Comments 
	(content,
	created_date,
	post_id) 
	
	values 
	(?,
	datetime(),
	?)', [content,post_id]

	redirect to ('/details/' + post_id)

end
