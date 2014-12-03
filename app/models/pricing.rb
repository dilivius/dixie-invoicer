class Pricing
  BRANCH_TO_TIER = {"L&K" => 5}
  DEFAULT_TIER = 1

  def initialize
    @@store ||= {}
  end

  def get(product_code, branch, customer)
    get_corporate(product_code, branch, customer) ||
      get_tiered(product_code, tier_of_branch(branch)) ||
      0
  end

  def set_tiered(product_code, tier, value)
    @@store[tiered_key(product_code, tier)] = value
  end

  def set_corporate(product_code, branch, customer, value)
    @@store[corporate_key(product_code, branch, customer)] = value
  end

  private

  def get_tiered(product_code, tier)
    @@store[tiered_key(product_code, tier)].try(:to_f)
  end

  def get_corporate(product_code, branch, customer)
    @@store[corporate_key(product_code, branch, customer)].try(:to_f)
  end

  def tier_of_branch(branch)
    BRANCH_TO_TIER.fetch(branch, DEFAULT_TIER)
  end

  def tiered_key(product_code, tier)
    "tiered:#{product_code}:#{tier}"
  end

  def corporate_key(product_code, branch, customer)
    "corporate:#{product_code}:#{branch}:#{customer}"
  end
end
