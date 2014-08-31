class Evento < ActiveRecord::Base

	#Subir imagenes
	mount_uploader :image, ImageUploader

	#Comentarios
	acts_as_commentable

	#Relaciones
	## Un evento tiene varios usuarios que asisten a el
	has_many :user_eventos
	has_many :users , through: :user_eventos

	#Pertenece al publicador que lo publico
	belongs_to :publicador


	#Validaciones
	validates :name, presence: true
	validates :subtitle, presence: true
	validates :publicador_id, presence: true
end
