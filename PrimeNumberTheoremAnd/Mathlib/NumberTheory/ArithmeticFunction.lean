import Mathlib.Data.Nat.Interval
import Mathlib.NumberTheory.ArithmeticFunction

open ArithmeticFunction BigOperators Nat Finset

namespace ArithmeticFunction

theorem sum_range_mul_zeta
    {R : Type*} [Semiring R] (f : ArithmeticFunction R) (N : ℕ) :
    ∑ d in range (N + 1), (f * ζ) d = ∑ d in range (N + 1), (N / d) • f d := by
  calc
    ∑ d in range (N + 1), (f * ζ) d
      = ∑ d in (range (N + 1) ×ˢ range (N + 1)).filter (fun d ↦ d.snd ∈ divisors d.fst),
        f d.snd := by
      simp_rw [sum_filter, sum_product]
      apply sum_congr rfl (fun x hx ↦ ?_)
      rw [← sum_filter, sum_congr (s₂ := divisors x) ?_ fun _ _ ↦ rfl, coe_mul_zeta_apply]
      refine Subset.antisymm ?_ ?_ <;> intro d hd
      · exact (mem_filter.mp hd).right
      · have h : d ≤ x := by
          rw [divisors, mem_filter] at hd
          exact lt_succ.mp (mem_Ico.mp hd.left).right
        exact mem_filter.mpr ⟨mem_range.mpr (lt_of_le_of_lt h $ mem_range.mp hx), hd⟩
    _ = ∑ d in range (N + 1), ∑ _m in (range (N + 1)).filter (d ∈ divisors ·), f d := by
      rw [sum_filter, sum_product_right]
      refine sum_congr rfl (fun y _ ↦ by simp only [← sum_filter])
    _ = ∑ d in range (N + 1), (N / d) • f d := by
      rw [sum_congr rfl fun y hy ↦ ?_]
      rw [sum_const]
      congr
      simp_rw [mem_divisors, and_comm (b := _ ≠ 0), ← filter_filter]
      have : (range (N + 1)).filter (· ≠ 0) = Icc 1 N := by
        ext a
        rw [mem_filter, mem_Icc, mem_range]
        constructor <;> intro ⟨h₁, h₂⟩
        · exact ⟨one_le_iff_ne_zero.mpr h₂, lt_succ.mp h₁⟩
        · exact ⟨lt_succ.mpr h₂, one_le_iff_ne_zero.mp h₁⟩
      by_cases hy' : 1 ≤ y
      · have hy'' := lt_succ.mp (mem_range.mp hy)
        rw [this, card_Icc_filter_dvd hy' $ hy'.trans hy'']
      · rw [not_le, lt_one_iff] at hy'
        subst hy'
        simp

theorem sum_Icc_mul_zeta
    {R : Type*} [Semiring R] (f : ArithmeticFunction R) (N : ℕ) :
    ∑ d in Icc 1 N, (f * ζ) d = ∑ d in Icc 1 N, (N / d) • f d := by
  have := sum_range_mul_zeta f N
  rw [range_eq_Ico, ← Ico_insert_succ_left, sum_insert, sum_insert] at this
  /- first goal -/
  simp only [Ico_succ_right, reduceSucc, Nat.div_zero, smul_zero, map_zero, zero_add] at this
  rw [this]
  /- remaining -/
  all_goals simp
