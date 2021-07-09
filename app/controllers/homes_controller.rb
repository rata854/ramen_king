class HomesController < ApplicationController
  
  def top
      @stores = Store.left_joins(:store_comments).distinct.sort_by do |store|
                    hoges = store.store_comments
                    if hoges.present?
                      hoges.map(&:rate).sum / hoges.size
                    else
                      0
                    end
                end.reverse
  end
  
  def about
  end
  
end
