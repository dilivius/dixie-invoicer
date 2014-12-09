class Pricing
  def get(product_code, branch, customer)
    get_corporate(product_code, branch, customer) ||
      get_branch(product_code, branch) ||
      0
  end

  def set_branch(product_code, branch, value)
    $redis.set(branch_key(product_code, branch), value)
  end

  def set_corporate(product_code, branch, customer, value)
    $redis.set(corporate_key(product_code, branch, customer), value)
  end

  private

  def get_branch(product_code, branch)
    $redis.get(branch_key(product_code, branch)).try(:to_f)
  end

  def get_corporate(product_code, branch, customer)
    $redis.get(corporate_key(product_code, branch, customer)).try(:to_f)
  end

  def branch_key(product_code, branch)
    "branch:#{product_code}:#{branch}"
  end

  def corporate_key(product_code, branch, customer)
    "corporate:#{product_code}:#{branch}:#{customer}"
  end
end
