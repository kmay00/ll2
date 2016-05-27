class Daily < ApplicationMailer
  def purchase_leads(purchase)
    @purchase = purchase
    mail(to: current_user, subject: "You've purchased new leads")
  end
end
