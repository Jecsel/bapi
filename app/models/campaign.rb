class Campaign < ApplicationRecord
  include SearchCop
  has_one_attached :upload_document
  
  belongs_to :campaign_client
  belongs_to :campaign_company
  belongs_to :campaign_billing
  belongs_to :campaign_doctor

  has_many :campaign_participants

  enum in_charge:["Dummy1", "Dummy2", "Dummy3"]

  search_scope :search do
    attributes :id, :event_name
    attributes campaign_client: ["campaign_client.name"]
    attributes campaign_billing: ["campaign_billing.name"]
  end

  def self.search_filter(filter_params)
    _sql =  joins(:campaign_client , :campaign_company, :campaign_billing)
    if filter_params[:status] == 0
      _sql = _sql.where(status: false)
    end
    if filter_params[:status] == 1
      _sql = _sql.where(status: true)
    end
    if filter_params[:campaign_date_start_from].present? || filter_params[:campaign_date_start_to].present?
      _sql = _sql.filter_by_campaign_date filter_params
    end 
    return _sql
  end

  def self.filter_by_campaign_date filter_params
    if filter_params[:campaign_date_start_from].present? && filter_params[:campaign_date_start_to].present?
        _start = filter_params[:campaign_date_start_from].to_date.beginning_of_day
        _end = filter_params[:campaign_date_start_to].to_date.end_of_day
        return where(campaigns:{created_at:[_start.._end]})
    end
    if filter_params[:campaign_date_start_from].present? && filter_params[:campaign_date_start_to].nil?
        _start = filter_params[:campaign_date_start_from].to_date.beginning_of_day
        return where("campaigns.campaign_start_date >= ?",_start)
    end
    if filter_params[:campaign_date_start_from].nil? && filter_params[:campaign_date_start_to].present?
        _end = filter_params[:campaign_date_start_to].to_date.end_of_day
        return where("campaigns.campaign_end_date <= ?",_end) 
    end
end
end
