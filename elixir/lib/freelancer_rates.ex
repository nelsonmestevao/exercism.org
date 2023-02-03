defmodule FreelancerRates do
  @hours_in_day 8.0
  @days_in_month 22.0

  def daily_rate(hourly_rate), do: hourly_rate * @hours_in_day

  def apply_discount(before_discount, discount) do
    before_discount * (100 - discount) / 100
  end

  def monthly_rate(hourly_rate, discount) do
    (@days_in_month * daily_rate(hourly_rate))
    |> apply_discount(discount)
    |> ceil()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    cost_per_day =
      daily_rate(hourly_rate)
      |> apply_discount(discount)

    (budget / cost_per_day)
    |> Float.floor(1)
  end
end
