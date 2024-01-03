class Servidor < ApplicationRecord
  has_one :componentes
  has_many :databases
  has_many :metricas
end
