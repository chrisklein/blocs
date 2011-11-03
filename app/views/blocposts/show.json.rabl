# app/views/blocposts/show.json.rabl

object @blocpost

attributes :content, :id

child :user do
	attributes :name
end