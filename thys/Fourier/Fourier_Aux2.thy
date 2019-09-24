section\<open>Lemmas destined for the development version\<close>

theory Fourier_Aux2
  imports Fourier_Aux1 Ergodic_Theory.SG_Library_Complement
begin

lemma has_integral_divide:
  fixes c :: "_ :: real_normed_div_algebra"
  shows "(f has_integral y) S \<Longrightarrow> ((\<lambda>x. f x / c) has_integral (y / c)) S"
  unfolding divide_inverse
  by (simp add: has_integral_mult_left)

lemma integral_sin [simp]:
  fixes a::real
  assumes "a \<le> b" shows "integral {a..b} sin = cos a - cos b"
proof -
  have "(sin has_integral (- cos b - - cos a)) {a..b}"
  proof (rule fundamental_theorem_of_calculus)
    show "((\<lambda>a. - cos a) has_vector_derivative sin x) (at x within {a..b})" for x
      unfolding has_field_derivative_iff_has_vector_derivative [symmetric]
      by (rule derivative_eq_intros | force)+
  qed (use assms in auto)
  then show ?thesis
    by (simp add: integral_unique)
qed

lemma integral_cos [simp]:
  fixes a::real
  assumes "a \<le> b" shows "integral {a..b} cos = sin b - sin a"
proof -
  have "(cos has_integral (sin b - sin a)) {a..b}"
  proof (rule fundamental_theorem_of_calculus)
    show "(sin has_vector_derivative cos x) (at x within {a..b})" for x
      unfolding has_field_derivative_iff_has_vector_derivative [symmetric]
      by (rule derivative_eq_intros | force)+
  qed (use assms in auto)
  then show ?thesis
    by (simp add: integral_unique)
qed

lemma has_integral_sin_nx: "((\<lambda>x. sin(real_of_int n * x)) has_integral 0) {-pi..pi}"
proof (cases "n = 0")
  case False
  have "((\<lambda>x. sin (n * x)) has_integral (- cos (n * pi)/n - - cos (n * - pi)/n)) {-pi..pi}"
  proof (rule fundamental_theorem_of_calculus)
    show "((\<lambda>x. - cos (n * x) / n) has_vector_derivative sin (n * a)) (at a within {-pi..pi})"
      if "a \<in> {-pi..pi}" for a :: real
      using that False
      apply (simp only: has_vector_derivative_def)
      apply (rule derivative_eq_intros | force)+
      done
  qed auto
  then show ?thesis
    by simp
qed auto

lemma integral_sin_nx:
   "integral {-pi..pi} (\<lambda>x. sin(x * real_of_int n)) = 0"
  using has_integral_sin_nx [of n] by (force simp: mult.commute)

lemma integral_sin_Z [simp]:
  assumes "n \<in> \<int>"
  shows "integral\<^sup>L (lebesgue_on {-pi..pi}) (\<lambda>x. sin(x * n)) = 0"
  proof (subst lebesgue_integral_eq_integral)
  show "integrable (lebesgue_on {-pi..pi}) (\<lambda>x. sin (x * n))"
    by (intro continuous_imp_integrable_real continuous_intros)
  show "integral {-pi..pi} (\<lambda>x. sin (x * n)) = 0"
    using assms Ints_cases integral_sin_nx by blast
qed auto

lemma integral_sin_Z' [simp]:
  assumes "n \<in> \<int>"
  shows "integral\<^sup>L (lebesgue_on {-pi..pi}) (\<lambda>x. sin(n * x)) = 0"
  by (metis assms integral_sin_Z mult_commute_abs)

lemma has_integral_cos_nx:
  "((\<lambda>x. cos(real_of_int n * x)) has_integral (if n = 0 then 2 * pi else 0)) {-pi..pi}"
proof (cases "n = 0")
  case True
  then show ?thesis
    using has_integral_const_real [of "1::real" "-pi" pi] by auto
next
  case False
  have "((\<lambda>x. cos (n * x)) has_integral (sin (n * pi)/n - sin (n * - pi)/n)) {-pi..pi}"
  proof (rule fundamental_theorem_of_calculus)
    show "((\<lambda>x. sin (n * x) / n) has_vector_derivative cos (n * x)) (at x within {-pi..pi})"
      if "x \<in> {-pi..pi}"
      for x :: real
      using that False
      apply (simp only: has_vector_derivative_def)
      apply (rule derivative_eq_intros | force)+
      done
  qed auto
  with False show ?thesis
    by (simp add: mult.commute)
qed

lemma integral_cos_nx:
   "integral {-pi..pi} (\<lambda>x. cos(x * real_of_int n)) = (if n = 0 then 2 * pi else 0)"
  using has_integral_cos_nx [of n] by (force simp: mult.commute)

lemma integral_cos_Z [simp]:
  assumes "n \<in> \<int>"
  shows "integral\<^sup>L (lebesgue_on {-pi..pi}) (\<lambda>x. cos(x * n)) = (if n = 0 then 2 * pi else 0)"
  proof (subst lebesgue_integral_eq_integral)
  show "integrable (lebesgue_on {-pi..pi}) (\<lambda>x. cos (x * n))"
    by (intro continuous_imp_integrable_real continuous_intros)
  show "integral {-pi..pi} (\<lambda>x. cos (x * n)) = (if n = 0 then 2 * pi else 0)"
    by (metis Ints_cases assms integral_cos_nx of_int_0_eq_iff)
qed auto

lemma integral_cos_Z' [simp]:
  assumes "n \<in> \<int>"
  shows "integral\<^sup>L (lebesgue_on {-pi..pi}) (\<lambda>x. cos(n * x)) = (if n = 0 then 2 * pi else 0)"
  by (metis assms integral_cos_Z mult_commute_abs)

lemma real_tendsto_mult_left_iff:
   "c \<noteq> 0 \<Longrightarrow> tendsto(\<lambda>x. c * f x) (c * l) F \<longleftrightarrow> tendsto f l F" for c :: real
  by (auto simp: tendsto_mult_left dest: tendsto_mult_left [where c = "1/c"])

lemma real_tendsto_mult_right_iff:
   "c \<noteq> 0 \<Longrightarrow> tendsto(\<lambda>x. f x * c) (l * c) F \<longleftrightarrow> tendsto f l F" for c :: real
  by (simp add: mult.commute real_tendsto_mult_left_iff)

lemma real_tendsto_zero_mult_right_iff [simp]:
  fixes c::real assumes "c \<noteq> 0" shows "(\<lambda>n. a n * c)\<longlonglongrightarrow> 0 \<longleftrightarrow> a \<longlonglongrightarrow> 0"
  by (metis assms mult_zero_left real_tendsto_mult_right_iff)

lemma real_tendsto_zero_divide_iff [simp]:
  fixes c::real assumes "c \<noteq> 0" shows "(\<lambda>n. a n / c)\<longlonglongrightarrow> 0 \<longleftrightarrow> a \<longlonglongrightarrow> 0"
  using real_tendsto_zero_mult_right_iff [of "1/c" a] assms by (simp add: field_simps)

lemma measurable_restrict_mono:
  assumes f: "f \<in> restrict_space M A \<rightarrow>\<^sub>M N" and "B \<subseteq> A"
  shows "f \<in> restrict_space M B \<rightarrow>\<^sub>M N"
by (rule measurable_compose[OF measurable_restrict_space3 f])
   (insert \<open>B \<subseteq> A\<close>, auto)

lemma borel_measurable_if_lebesgue_on:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "S \<in> sets lebesgue" "T \<in> sets lebesgue" "S \<subseteq> T"
  shows "(\<lambda>x. if x \<in> S then f x else 0) \<in> borel_measurable (lebesgue_on T) \<longleftrightarrow> f \<in> borel_measurable (lebesgue_on S)"
  (is "?lhs = ?rhs")
proof
  assume ?lhs then show ?rhs
    using measurable_restrict_mono [OF _ \<open>S \<subseteq> T\<close>]
    by (subst measurable_lebesgue_cong [where g = "(\<lambda>x. if x \<in> S then f x else 0)"]) auto
next
  assume ?rhs then show ?lhs
  by (simp add: \<open>S \<in> sets lebesgue\<close> borel_measurable_if_I measurable_restrict_space1)
qed


lemma insert_sets_lebesgue_on:
  assumes "A \<in> sets (lebesgue_on S)" "a \<in> S" "S \<in> sets lebesgue"
  shows "insert a A \<in> sets (lebesgue_on S)"
  by (metis assms borel_singleton insert_subset lborelD sets.Int_space_eq2 sets.empty_sets sets.insert_in_sets sets_completionI_sets sets_restrict_space_iff)

lemma integrable_lebesgue_on_empty [iff]:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::{second_countable_topology,banach}"
  shows "integrable (lebesgue_on {}) f"
  by (simp add: integrable_restrict_space)

lemma integral_lebesgue_on_empty [simp]:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::{second_countable_topology,banach}"
  shows "integral\<^sup>L (lebesgue_on {}) f = 0"
  by (simp add: Bochner_Integration.integral_empty)

lemma odd_even_cases [case_names 0 odd even]:
  assumes "P 0" and odd: "\<And>n. P(Suc (2 * n))" and even: "\<And>n. P(2 * n + 2)"
  shows "P n"
  by (metis nat_induct2 One_nat_def Suc_1 add_Suc_right assms(1) dvdE even odd oddE)

lemma null_AE_impI: "\<lbrakk>N \<in> null_sets (lebesgue_on S); S \<in> sets lebesgue\<rbrakk> \<Longrightarrow> AE x in lebesgue_on S. x \<in> N \<longrightarrow> P x"
  by (rule AE_I' [of N]) auto

lemma has_bochner_integral_restrict_space:
  fixes f :: "'a \<Rightarrow> 'b::{banach, second_countable_topology}"
  assumes \<Omega>: "\<Omega> \<inter> space M \<in> sets M"
  shows "has_bochner_integral (restrict_space M \<Omega>) f i
     \<longleftrightarrow> has_bochner_integral M (\<lambda>x. indicator \<Omega> x *\<^sub>R f x) i"
  by (simp add: integrable_restrict_space [OF assms] integral_restrict_space [OF assms] has_bochner_integral_iff)

lemma integrable_restrict_UNIV:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::{banach, second_countable_topology}"
  assumes S: "S \<in> sets lebesgue"
  shows  "integrable lebesgue (\<lambda>x. if x \<in> S then f x else 0) \<longleftrightarrow> integrable (lebesgue_on S) f"
  using has_bochner_integral_restrict_space [of S lebesgue f] assms
  by (simp add: integrable.simps indicator_scaleR_eq_if)

lemma integral_mono_lebesgue_on_AE:
  fixes f::"_ \<Rightarrow> real"
  assumes f: "integrable (lebesgue_on T) f"
    and gf: "AE x in (lebesgue_on S). g x \<le> f x"
    and f0: "AE x in (lebesgue_on T). 0 \<le> f x"
    and "S \<subseteq> T" and S: "S \<in> sets lebesgue" and T: "T \<in> sets lebesgue"
  shows "(\<integral>x. g x \<partial>(lebesgue_on S)) \<le> (\<integral>x. f x \<partial>(lebesgue_on T))"
proof -
  have "(\<integral>x. g x \<partial>(lebesgue_on S)) = (\<integral>x. (if x \<in> S then g x else 0) \<partial>lebesgue)"
    by (simp add: integral_restrict_UNIV S)
  also have "\<dots> \<le> (\<integral>x. (if x \<in> T then f x else 0) \<partial>lebesgue)"
  proof (rule Bochner_Integration.integral_mono_AE')
    show "integrable lebesgue (\<lambda>x. if x \<in> T then f x else 0)"
      by (simp add: integrable_restrict_UNIV T f)
    show "AE x in lebesgue. (if x \<in> S then g x else 0) \<le> (if x \<in> T then f x else 0)"
      using assms by (auto simp: AE_restrict_space_iff)
    show "AE x in lebesgue. 0 \<le> (if x \<in> T then f x else 0)"
      using f0 by (simp add: AE_restrict_space_iff T)
  qed
  also have "\<dots> = (\<integral>x. f x \<partial>(lebesgue_on T))"
    using integral_restrict_UNIV T by blast
  finally show ?thesis .
qed



lemma integrable_subinterval_real:
  fixes f :: "real \<Rightarrow> 'a::euclidean_space"
  assumes "integrable (lebesgue_on {a..b}) f"
    and "{c..d} \<subseteq> {a..b}"
  shows "integrable (lebesgue_on {c..d}) f"
  by (metis (full_types) absolutely_integrable_on_def assms fmeasurableD integrable_restrict_space integrable_subinterval_real interval_cbox lmeasurable_cbox set_integrable_def sets.Int_space_eq2)


lemma indefinite_integral_continuous_1:
  fixes f :: "real \<Rightarrow> 'a::euclidean_space"
  assumes "integrable (lebesgue_on {a..b}) f"
  shows "continuous_on {a..b} (\<lambda>x. integral\<^sup>L (lebesgue_on {a..x}) f)"
proof -
  have "f integrable_on {a..b}"
    by (simp add: assms integrable_on_lebesgue_on)
  then have "continuous_on {a..b} (\<lambda>x. integral {a..x} f)"
    using indefinite_integral_continuous_1 by blast
  moreover have "integral\<^sup>L (lebesgue_on {a..x}) f = integral {a..x} f" if "a \<le> x" "x \<le> b" for x
  proof -
    have "{a..x} \<subseteq> {a..b}"
      using that by auto
    then have "integrable (lebesgue_on {a..x}) f"
      using integrable_subinterval_real assms by blast
    then show "integral\<^sup>L (lebesgue_on {a..x}) f = integral {a..x} f"
      by (smt integrable_restrict_UNIV integral_restrict_UNIV Henstock_Kurzweil_Integration.integral_restrict_UNIV atLeastAtMost_borel integral_lebesgue sets_completionI_sets sets_lborel)
  qed
  ultimately show ?thesis
    by (metis (no_types, lifting) atLeastAtMost_iff continuous_on_cong)
qed


lemma AE_null_sets_lebesgue:
  assumes "AE x in lebesgue. P x"
  obtains N where "N \<in> null_sets lebesgue" "\<And>x. x \<notin> N \<Longrightarrow> P x"
  using assms unfolding completion.AE_iff_null_sets  by auto


lemma measure_lebesgue_on_ivl [simp]: "\<lbrakk>{a..b} \<subseteq> S; S \<in> sets lebesgue\<rbrakk> \<Longrightarrow> measure (lebesgue_on S) {a..b} = content {a..b::real}"
  by (simp add: measure_restrict_space)



subsection\<open>Linear functions are (uniformly) continuous on any set\<close>

lemma linear_lim_0:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::real_normed_vector"
  assumes "linear f"
  shows "(f \<longlongrightarrow> 0) (at 0)"
proof -
  obtain B where "B > 0" "\<And>x. norm (f x) \<le> B * norm x"
    using assms linear_bounded_pos by blast
  then have "\<And>e x. \<lbrakk>0 < e; x \<noteq> 0; norm x < e / B\<rbrakk> \<Longrightarrow> norm (f x) < e"
    by (metis le_less_trans mult.commute pos_less_divide_eq)
  then show ?thesis
    unfolding Lim_at dist_norm
    by (metis \<open>0 < B\<close> diff_zero divide_pos_pos zero_less_norm_iff)
qed

lemma linear_continuous_at:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::real_normed_vector"
  assumes "linear f"
  shows "continuous (at a) f"
  using assms has_derivative_continuous linear_imp_has_derivative by blast


lemma linear_continuous_within:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::real_normed_vector"
  assumes "linear f"
  shows "continuous (at x within S) f"
  by (simp add: assms differentiable_imp_continuous_within linear_imp_differentiable)

lemma linear_continuous_on:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::real_normed_vector"
  assumes "linear f"
  shows "continuous_on S f"
  by (simp add: continuous_at_imp_continuous_on linear_continuous_within assms)

lemma Lim_linear:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space" and h :: "'b \<Rightarrow> 'c::real_normed_vector"
  assumes "(f \<longlongrightarrow> l) F" "linear h"
  shows "((\<lambda>x. h(f x)) \<longlongrightarrow> h l) F"
proof -
  obtain B where B: "B > 0" "\<And>x. norm (h x) \<le> B * norm x"
    using linear_bounded_pos [OF \<open>linear h\<close>] by blast
  show ?thesis
    unfolding tendsto_iff
  proof (intro allI impI)
    show "\<forall>\<^sub>F x in F. dist (h (f x)) (h l) < e" if "e > 0" for e
    proof -
      have "\<forall>\<^sub>F x in F. dist (f x) l < e/B"
        by (simp add: \<open>0 < B\<close> assms(1) tendstoD that)
      then show ?thesis
        unfolding dist_norm
      proof (rule eventually_mono)
        show "norm (h (f x) - h l) < e" if "norm (f x - l) < e / B" for x
          using that B
          apply (simp add: divide_simps)
          by (metis \<open>linear h\<close> le_less_trans linear_diff mult.commute)
      qed
    qed
  qed
qed

lemma linear_continuous_compose:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space" and g :: "'b \<Rightarrow> 'c::real_normed_vector"
  assumes "continuous F f" "linear g"
  shows "continuous F (\<lambda>x. g(f x))"
  using assms unfolding continuous_def by (rule Lim_linear)

lemma linear_continuous_on_compose:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space" and g :: "'b \<Rightarrow> 'c::real_normed_vector"
  assumes "continuous_on S f" "linear g"
  shows "continuous_on S (\<lambda>x. g(f x))"
  using assms by (simp add: continuous_on_eq_continuous_within linear_continuous_compose)


subsection\<open>Also bilinear functions, in composition form\<close>


lemma bilinear_continuous_compose:
  fixes h :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space \<Rightarrow> 'c::real_normed_vector"
  assumes "continuous F f" "continuous F g" "bilinear h"
  shows "continuous F (\<lambda>x. h (f x) (g x))"
  using assms Lim_bilinear bilinear_conv_bounded_bilinear
  unfolding continuous_def
  by blast

lemma bilinear_continuous_on_compose:
  fixes h :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space \<Rightarrow> 'c::real_normed_vector"
    and f :: "'d::t2_space \<Rightarrow> 'a"
  assumes "continuous_on S f" "continuous_on S g" "bilinear h"
  shows "continuous_on S (\<lambda>x. h (f x) (g x))"
  using assms
  by (simp add: continuous_on_eq_continuous_within bilinear_continuous_compose)





subsection\<open>Austin's Lemma\<close>

lemma Austin_Lemma:
  fixes \<D> :: "'a::euclidean_space set set"
  assumes "finite \<D>" and \<D>: "\<And>D. D \<in> \<D> \<Longrightarrow> \<exists>k a b. D = cbox a b \<and> (\<forall>i \<in> Basis. b\<bullet>i - a\<bullet>i = k)"
  obtains \<C> where "\<C> \<subseteq> \<D>" "pairwise disjnt \<C>"
                  "measure lebesgue (\<Union>\<C>) \<ge> measure lebesgue (\<Union>\<D>) / 3 ^ (DIM('a))"
  using assms
proof (induction "card \<D>" arbitrary: \<D> thesis rule: less_induct)
  case less
  show ?case
  proof (cases "\<D> = {}")
    case True
    then show thesis
      using less by auto
  next
    case False
    then have "Max (Sigma_Algebra.measure lebesgue ` \<D>) \<in> Sigma_Algebra.measure lebesgue ` \<D>"
      using Max_in finite_imageI \<open>finite \<D>\<close> by blast
    then obtain D where "D \<in> \<D>" and "measure lebesgue D = Max (measure lebesgue ` \<D>)"
      by auto
    then have D: "\<And>C. C \<in> \<D> \<Longrightarrow> measure lebesgue C \<le> measure lebesgue D"
      by (simp add: \<open>finite \<D>\<close>)
    let ?\<E> = "{C. C \<in> \<D> - {D} \<and> disjnt C D}"
    obtain \<D>' where \<D>'sub: "\<D>' \<subseteq> ?\<E>" and \<D>'dis: "pairwise disjnt \<D>'"
      and \<D>'m: "measure lebesgue (\<Union>\<D>') \<ge> measure lebesgue (\<Union>?\<E>) / 3 ^ (DIM('a))"
    proof (rule less.hyps)
      have *: "?\<E> \<subset> \<D>"
        using \<open>D \<in> \<D>\<close> by auto
      then show "card ?\<E> < card \<D>" "finite ?\<E>"
        by (auto simp: \<open>finite \<D>\<close> psubset_card_mono)
      show "\<exists>k a b. D = cbox a b \<and> (\<forall>i\<in>Basis. b \<bullet> i - a \<bullet> i = k)" if "D \<in> ?\<E>" for D
        using less.prems(3) that by auto
    qed
    then have [simp]: "\<Union>\<D>' - D = \<Union>\<D>'"
      by (auto simp: disjnt_iff)
    show ?thesis
    proof (rule less.prems)
      show "insert D \<D>' \<subseteq> \<D>"
        using \<D>'sub \<open>D \<in> \<D>\<close> by blast
      show "disjoint (insert D \<D>')"
        using \<D>'dis \<D>'sub by (fastforce simp add: pairwise_def disjnt_sym)
      obtain a3 b3 where  m3: "content (cbox a3 b3) = 3 ^ DIM('a) * measure lebesgue D"
        and sub3: "\<And>C. \<lbrakk>C \<in> \<D>; \<not> disjnt C D\<rbrakk> \<Longrightarrow> C \<subseteq> cbox a3 b3"
      proof -
        obtain k a b where ab: "D = cbox a b" and k: "\<And>i. i \<in> Basis \<Longrightarrow> b\<bullet>i - a\<bullet>i = k"
          using less.prems \<open>D \<in> \<D>\<close> by blast
        then have eqk: "\<And>i. i \<in> Basis \<Longrightarrow> a \<bullet> i \<le> b \<bullet> i \<longleftrightarrow> k \<ge> 0"
          by force
        show thesis
        proof
          let ?a = "(a + b) /\<^sub>R 2 - (3/2) *\<^sub>R (b - a)"
          let ?b = "(a + b) /\<^sub>R 2 + (3/2) *\<^sub>R (b - a)"
          have eq: "(\<Prod>i\<in>Basis. b \<bullet> i * 3 - a \<bullet> i * 3) = (\<Prod>i\<in>Basis. b \<bullet> i - a \<bullet> i) * 3 ^ DIM('a)"
            by (simp add: comm_monoid_mult_class.prod.distrib flip: left_diff_distrib inner_diff_left)
          show "content (cbox ?a ?b) = 3 ^ DIM('a) * measure lebesgue D"
            by (simp add: content_cbox_if box_eq_empty algebra_simps eq ab k)
          show "C \<subseteq> cbox ?a ?b" if "C \<in> \<D>" and CD: "\<not> disjnt C D" for C
          proof -
            obtain k' a' b' where ab': "C = cbox a' b'" and k': "\<And>i. i \<in> Basis \<Longrightarrow> b'\<bullet>i - a'\<bullet>i = k'"
              using less.prems \<open>C \<in> \<D>\<close> by blast
            then have eqk': "\<And>i. i \<in> Basis \<Longrightarrow> a' \<bullet> i \<le> b' \<bullet> i \<longleftrightarrow> k' \<ge> 0"
              by force
            show ?thesis
            proof (clarsimp simp add: disjoint_interval disjnt_def ab ab' not_less subset_box algebra_simps)
              show "a \<bullet> i * 2 \<le> a' \<bullet> i + b \<bullet> i \<and> a \<bullet> i + b' \<bullet> i \<le> b \<bullet> i * 2"
                if * [rule_format]: "\<forall>j\<in>Basis. a' \<bullet> j \<le> b' \<bullet> j" and "i \<in> Basis" for i
              proof -
                have "a' \<bullet> i \<le> b' \<bullet> i \<and> a \<bullet> i \<le> b \<bullet> i \<and> a \<bullet> i \<le> b' \<bullet> i \<and> a' \<bullet> i \<le> b \<bullet> i"
                  using \<open>i \<in> Basis\<close> CD by (simp_all add: disjoint_interval disjnt_def ab ab' not_less)
                then show ?thesis
                  using D [OF \<open>C \<in> \<D>\<close>] \<open>i \<in> Basis\<close>
                  apply (simp add: ab ab' k k' eqk eqk' content_cbox_cases)
                  using k k' by fastforce
              qed
            qed
          qed
        qed
      qed
      have \<D>lm: "\<And>D. D \<in> \<D> \<Longrightarrow> D \<in> lmeasurable"
        using less.prems(3) by blast
      have "measure lebesgue (\<Union>\<D>)  \<le> measure lebesgue (cbox a3 b3 \<union> (\<Union>\<D> - cbox a3 b3))"
      proof (rule measure_mono_fmeasurable)
        show "\<Union>\<D> \<in> sets lebesgue"
          using \<D>lm \<open>finite \<D>\<close> by blast
        show "cbox a3 b3 \<union> (\<Union>\<D> - cbox a3 b3) \<in> lmeasurable"
          by (simp add: \<D>lm fmeasurable.Un fmeasurable.finite_Union less.prems(2) subset_eq)
      qed auto
      also have "\<dots> = content (cbox a3 b3) + measure lebesgue (\<Union>\<D> - cbox a3 b3)"
        by (simp add: \<D>lm fmeasurable.finite_Union less.prems(2) measure_Un2 subsetI)
      also have "\<dots> \<le> (measure lebesgue D + measure lebesgue (\<Union>\<D>')) * 3 ^ DIM('a)"
      proof -
        have "(\<Union>\<D> - cbox a3 b3) \<subseteq> \<Union>?\<E>"
          using sub3 by fastforce
        then have "measure lebesgue (\<Union>\<D> - cbox a3 b3) \<le> measure lebesgue (\<Union>?\<E>)"
        proof (rule measure_mono_fmeasurable)
          show "\<Union> \<D> - cbox a3 b3 \<in> sets lebesgue"
            by (simp add: \<D>lm fmeasurableD less.prems(2) sets.Diff sets.finite_Union subsetI)
          show "\<Union> {C \<in> \<D> - {D}. disjnt C D} \<in> lmeasurable"
            using \<D>lm less.prems(2) by auto
        qed
        then have "measure lebesgue (\<Union>\<D> - cbox a3 b3) / 3 ^ DIM('a) \<le> measure lebesgue (\<Union> \<D>')"
          using \<D>'m by (simp add: divide_simps)
        then show ?thesis
          by (simp add: m3 field_simps)
      qed
      also have "\<dots> \<le> measure lebesgue (\<Union>(insert D \<D>')) * 3 ^ DIM('a)"
      proof (simp add: \<D>lm \<open>D \<in> \<D>\<close>)
        show "measure lebesgue D + measure lebesgue (\<Union>\<D>') \<le> measure lebesgue (D \<union> \<Union> \<D>')"
        proof (subst measure_Un2)
          show "\<Union> \<D>' \<in> lmeasurable"
            by (meson \<D>lm \<open>insert D \<D>' \<subseteq> \<D>\<close> fmeasurable.finite_Union less.prems(2) finite_subset subset_eq subset_insertI)
          show "measure lebesgue D + measure lebesgue (\<Union> \<D>') \<le> measure lebesgue D + measure lebesgue (\<Union> \<D>' - D)"
            using \<open>insert D \<D>' \<subseteq> \<D>\<close> infinite_super less.prems(2) by force
        qed (simp add: \<D>lm \<open>D \<in> \<D>\<close>)
      qed
      finally show "measure lebesgue (\<Union>\<D>) / 3 ^ DIM('a) \<le> measure lebesgue (\<Union>(insert D \<D>'))"
        by (simp add: divide_simps)
    qed
  qed
qed


subsection\<open>A differentiability-like property of the indefinite integral.        \<close>

proposition integrable_ccontinuous_explicit:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "\<And>a b::'a. f integrable_on cbox a b"
  obtains N where
       "negligible N"
       "\<And>x e. \<lbrakk>x \<notin> N; 0 < e\<rbrakk> \<Longrightarrow>
               \<exists>d>0. \<forall>h. 0 < h \<and> h < d \<longrightarrow>
                         norm(integral (cbox x (x + h *\<^sub>R One)) f /\<^sub>R h ^ DIM('a) - f x) < e"
proof -
  define BOX where "BOX \<equiv> \<lambda>h. \<lambda>x::'a. cbox x (x + h *\<^sub>R One)"
  define BOX2 where "BOX2 \<equiv> \<lambda>h. \<lambda>x::'a. cbox (x - h *\<^sub>R One) (x + h *\<^sub>R One)"
  define i where "i \<equiv> \<lambda>h x. integral (BOX h x) f /\<^sub>R h ^ DIM('a)"
  define \<Psi> where "\<Psi> \<equiv> \<lambda>x r. \<forall>d>0. \<exists>h. 0 < h \<and> h < d \<and> r \<le> norm(i h x - f x)"
  let ?N = "{x. \<exists>e>0. \<Psi> x e}"
  have "\<exists>N. negligible N \<and> (\<forall>x e. x \<notin> N \<and> 0 < e \<longrightarrow> \<not> \<Psi> x e)"
  proof (rule exI ; intro conjI allI impI)
    let ?M =  "\<Union>n. {x. \<Psi> x (inverse(real n + 1))}"
    have "negligible ({x. \<Psi> x \<mu>} \<inter> cbox a b)"
      if "\<mu> > 0" for a b \<mu>
    proof (cases "negligible(cbox a b)")
      case True
      then show ?thesis
        by (simp add: negligible_Int)
    next
      case False
      then have "box a b \<noteq> {}"
        by (simp add: negligible_interval)
      then have ab: "\<And>i. i \<in> Basis \<Longrightarrow> a\<bullet>i < b\<bullet>i"
        by (simp add: box_ne_empty)
      show ?thesis
        unfolding negligible_outer_le
      proof (intro allI impI)
        fix e::real
        let ?ee = "(e * \<mu>) / 2 / 6 ^ (DIM('a))"
        assume "e > 0"
        then have gt0: "?ee > 0"
          using \<open>\<mu> > 0\<close> by auto
        have f': "f integrable_on cbox (a - One) (b + One)"
          using assms by blast
        obtain \<gamma> where "gauge \<gamma>"
          and \<gamma>: "\<And>p. \<lbrakk>p tagged_partial_division_of (cbox (a - One) (b + One)); \<gamma> fine p\<rbrakk>
                    \<Longrightarrow> (\<Sum>(x, k)\<in>p. norm (content k *\<^sub>R f x - integral k f)) < ?ee"
          using Henstock_lemma [OF f' gt0] that by auto
        let ?E = "{x. x \<in> cbox a b \<and> \<Psi> x \<mu>}"
        have "\<exists>h>0. BOX h x \<subseteq> \<gamma> x \<and>
                    BOX h x \<subseteq> cbox (a - One) (b + One) \<and> \<mu> \<le> norm (i h x - f x)"
          if "x \<in> cbox a b" "\<Psi> x \<mu>" for x
        proof -
          obtain d where "d > 0" and d: "ball x d \<subseteq> \<gamma> x"
            using gaugeD [OF \<open>gauge \<gamma>\<close>, of x] openE by blast
          then obtain h where "0 < h" "h < 1" and hless: "h < d / real DIM('a)"
                          and mule: "\<mu> \<le> norm (i h x - f x)"
            using \<open>\<Psi> x \<mu>\<close> [unfolded \<Psi>_def, rule_format, of "min 1 (d / DIM('a))"]
            by auto
          show ?thesis
          proof (intro exI conjI)
            show "0 < h" "\<mu> \<le> norm (i h x - f x)" by fact+
            have "BOX h x \<subseteq> ball x d"
            proof (clarsimp simp: BOX_def mem_box dist_norm algebra_simps)
              fix y
              assume "\<forall>i\<in>Basis. x \<bullet> i \<le> y \<bullet> i \<and> y \<bullet> i \<le> h + x \<bullet> i"
              then have lt: "\<bar>(x - y) \<bullet> i\<bar> < d / real DIM('a)" if "i \<in> Basis" for i
                using hless that by (force simp: inner_diff_left)
              have "norm (x - y) \<le> (\<Sum>i\<in>Basis. \<bar>(x - y) \<bullet> i\<bar>)"
                using norm_le_l1 by blast
              also have "\<dots> < d"
                using sum_bounded_above_strict [of Basis "\<lambda>i. \<bar>(x - y) \<bullet> i\<bar>" "d / DIM('a)", OF lt]
                by auto
              finally show "norm (x - y) < d" .
            qed
            with d show "BOX h x \<subseteq> \<gamma> x"
              by blast
            show "BOX h x \<subseteq> cbox (a - One) (b + One)"
              using that \<open>h < 1\<close>
              by (force simp: BOX_def mem_box algebra_simps intro: subset_box_imp)
          qed
        qed
        then obtain \<eta> where h0: "\<And>x. x \<in> ?E \<Longrightarrow> \<eta> x > 0"
          and BOX_\<gamma>: "\<And>x. x \<in> ?E \<Longrightarrow> BOX (\<eta> x) x \<subseteq> \<gamma> x"
          and "\<And>x. x \<in> ?E \<Longrightarrow> BOX (\<eta> x) x \<subseteq> cbox (a - One) (b + One) \<and> \<mu> \<le> norm (i (\<eta> x) x - f x)"
          by simp metis
        then have BOX_cbox: "\<And>x. x \<in> ?E \<Longrightarrow> BOX (\<eta> x) x \<subseteq> cbox (a - One) (b + One)"
             and \<mu>_le: "\<And>x. x \<in> ?E \<Longrightarrow> \<mu> \<le> norm (i (\<eta> x) x - f x)"
          by blast+
        define \<gamma>' where "\<gamma>' \<equiv> \<lambda>x. if x \<in> cbox a b \<and> \<Psi> x \<mu> then ball x (\<eta> x) else \<gamma> x"
        have "gauge \<gamma>'"
          using \<open>gauge \<gamma>\<close> by (auto simp: h0 gauge_def \<gamma>'_def)
        obtain \<D> where "countable \<D>"
          and \<D>: "\<Union>\<D> \<subseteq> cbox a b"
          "\<And>K. K \<in> \<D> \<Longrightarrow> interior K \<noteq> {} \<and> (\<exists>c d. K = cbox c d)"
          and Dcovered: "\<And>K. K \<in> \<D> \<Longrightarrow> \<exists>x. x \<in> cbox a b \<and> \<Psi> x \<mu> \<and> x \<in> K \<and> K \<subseteq> \<gamma>' x"
          and subUD: "?E \<subseteq> \<Union>\<D>"
          by (rule covering_lemma [of ?E a b \<gamma>']) (simp_all add: Bex_def \<open>box a b \<noteq> {}\<close> \<open>gauge \<gamma>'\<close>)
        then have "\<D> \<subseteq> sets lebesgue"
          by fastforce
        show "\<exists>T. {x. \<Psi> x \<mu>} \<inter> cbox a b \<subseteq> T \<and> T \<in> lmeasurable \<and> measure lebesgue T \<le> e"
        proof (intro exI conjI)
          show "{x. \<Psi> x \<mu>} \<inter> cbox a b \<subseteq> \<Union>\<D>"
            apply auto
            using subUD by auto
          have mUE: "measure lebesgue (\<Union> \<E>) \<le> measure lebesgue (cbox a b)"
            if "\<E> \<subseteq> \<D>" "finite \<E>" for \<E>
          proof (rule measure_mono_fmeasurable)
            show "\<Union> \<E> \<subseteq> cbox a b"
              using \<D>(1) that(1) by blast
            show "\<Union> \<E> \<in> sets lebesgue"
              by (metis \<D>(2) fmeasurable.finite_Union fmeasurableD lmeasurable_cbox subset_eq that)
          qed auto
          then show "\<Union>\<D> \<in> lmeasurable"
            by (metis \<D>(2) \<open>countable \<D>\<close> fmeasurable_Union_bound lmeasurable_cbox)
          then have leab: "measure lebesgue (\<Union>\<D>) \<le> measure lebesgue (cbox a b)"
            by (meson \<D>(1) fmeasurableD lmeasurable_cbox measure_mono_fmeasurable)
          obtain \<F> where "\<F> \<subseteq> \<D>" "finite \<F>"
            and \<F>: "measure lebesgue (\<Union>\<D>) \<le> 2 * measure lebesgue (\<Union>\<F>)"
          proof (cases "measure lebesgue (\<Union>\<D>) = 0")
            case True
            then show ?thesis
              by (force intro: that [where \<F> = "{}"])
          next
            case False
            obtain \<F> where "\<F> \<subseteq> \<D>" "finite \<F>"
              and \<F>: "measure lebesgue (\<Union>\<D>)/2 < measure lebesgue (\<Union>\<F>)"
            proof (rule measure_countable_Union_approachable [of \<D> "measure lebesgue (\<Union>\<D>) / 2" "content (cbox a b)"])
              show "countable \<D>"
                by fact
              show "0 < measure lebesgue (\<Union> \<D>) / 2"
                using False by (simp add: zero_less_measure_iff)
              show Dlm: "D \<in> lmeasurable" if "D \<in> \<D>" for D
                using \<D>(2) that by blast
              show "measure lebesgue (\<Union> \<F>) \<le> content (cbox a b)"
                if "\<F> \<subseteq> \<D>" "finite \<F>" for \<F>
              proof -
                have "measure lebesgue (\<Union> \<F>) \<le> measure lebesgue (\<Union>\<D>)"
                proof (rule measure_mono_fmeasurable)
                  show "\<Union> \<F> \<subseteq> \<Union> \<D>"
                    by (simp add: Sup_subset_mono \<open>\<F> \<subseteq> \<D>\<close>)
                  show "\<Union> \<F> \<in> sets lebesgue"
                    by (meson Dlm fmeasurableD sets.finite_Union subset_eq that)
                  show "\<Union> \<D> \<in> lmeasurable"
                    by fact
                qed
                also have "\<dots> \<le> measure lebesgue (cbox a b)"
                proof (rule measure_mono_fmeasurable)
                  show "\<Union> \<D> \<in> sets lebesgue"
                    by (simp add: \<open>\<Union> \<D> \<in> lmeasurable\<close> fmeasurableD)
                qed (auto simp:\<D>(1))
                finally show ?thesis
                  by simp
              qed
            qed auto
            then show ?thesis
              using that by auto
          qed
          obtain tag where tag_in_E: "\<And>D. D \<in> \<D> \<Longrightarrow> tag D \<in> ?E"
            and tag_in_self: "\<And>D. D \<in> \<D> \<Longrightarrow> tag D \<in> D"
            and tag_sub: "\<And>D. D \<in> \<D> \<Longrightarrow> D \<subseteq> \<gamma>' (tag D)"
            using Dcovered by simp metis
          then have sub_ball_tag: "\<And>D. D \<in> \<D> \<Longrightarrow> D \<subseteq> ball (tag D) (\<eta> (tag D))"
            by (simp add: \<gamma>'_def)
          define \<Phi> where "\<Phi> \<equiv> \<lambda>D. BOX (\<eta>(tag D)) (tag D)"
          define \<Phi>2 where "\<Phi>2 \<equiv> \<lambda>D. BOX2 (\<eta>(tag D)) (tag D)"
          obtain \<C> where "\<C> \<subseteq> \<Phi>2 ` \<F>" "pairwise disjnt \<C>"
            "measure lebesgue (\<Union>\<C>) \<ge> measure lebesgue (\<Union>(\<Phi>2`\<F>)) / 3 ^ (DIM('a))"
          proof (rule Austin_Lemma)
            show "finite (\<Phi>2`\<F>)"
              using \<open>finite \<F>\<close> by blast
            have "\<exists>k a b. \<Phi>2 D = cbox a b \<and> (\<forall>i\<in>Basis. b \<bullet> i - a \<bullet> i = k)" if "D \<in> \<F>" for D
              apply (rule_tac x="2 * \<eta>(tag D)" in exI)
              apply (rule_tac x="tag D - \<eta>(tag D) *\<^sub>R One" in exI)
              apply (rule_tac x="tag D + \<eta>(tag D) *\<^sub>R One" in exI)
              using that
              apply (auto simp: \<Phi>2_def BOX2_def algebra_simps)
              done
            then show "\<And>D. D \<in> \<Phi>2 ` \<F> \<Longrightarrow> \<exists>k a b. D = cbox a b \<and> (\<forall>i\<in>Basis. b \<bullet> i - a \<bullet> i = k)"
              by blast
          qed auto
          then obtain \<G> where "\<G> \<subseteq> \<F>" and disj: "pairwise disjnt (\<Phi>2 ` \<G>)"
            and "measure lebesgue (\<Union>(\<Phi>2 ` \<G>)) \<ge> measure lebesgue (\<Union>(\<Phi>2`\<F>)) / 3 ^ (DIM('a))"
            unfolding \<Phi>2_def subset_image_iff
            by (meson empty_subsetI equals0D pairwise_imageI)
          moreover
          have "measure lebesgue (\<Union>(\<Phi>2 ` \<G>)) * 3 ^ DIM('a) \<le> e/2"
          proof -
            have "finite \<G>"
              using \<open>finite \<F>\<close> \<open>\<G> \<subseteq> \<F>\<close> infinite_super by blast
            have BOX2_m: "\<And>x. x \<in> tag ` \<G> \<Longrightarrow> BOX2 (\<eta> x) x \<in> lmeasurable"
              by (auto simp: BOX2_def)
            have BOX_m: "\<And>x. x \<in> tag ` \<G> \<Longrightarrow> BOX (\<eta> x) x \<in> lmeasurable"
              by (auto simp: BOX_def)
            have BOX_sub: "BOX (\<eta> x) x \<subseteq> BOX2 (\<eta> x) x" for x
              by (auto simp: BOX_def BOX2_def subset_box algebra_simps)
            have DISJ2: "BOX2 (\<eta> (tag X)) (tag X) \<inter> BOX2 (\<eta> (tag Y)) (tag Y) = {}"
              if "X \<in> \<G>" "Y \<in> \<G>" "tag X \<noteq> tag Y" for X Y
            proof -
              obtain i where i: "i \<in> Basis" "tag X \<bullet> i \<noteq> tag Y \<bullet> i"
                using \<open>tag X \<noteq> tag Y\<close> by (auto simp: euclidean_eq_iff [of "tag X"])
              have XY: "X \<in> \<D>" "Y \<in> \<D>"
                using \<open>\<F> \<subseteq> \<D>\<close> \<open>\<G> \<subseteq> \<F>\<close> that by auto
              then have "0 \<le> \<eta> (tag X)" "0 \<le> \<eta> (tag Y)"
                by (meson h0 le_cases not_le tag_in_E)+
              with XY i have "BOX2 (\<eta> (tag X)) (tag X) \<noteq> BOX2 (\<eta> (tag Y)) (tag Y)"
                unfolding eq_iff
                by (fastforce simp add: BOX2_def subset_box algebra_simps)
              then show ?thesis
                using disj that by (auto simp: pairwise_def disjnt_def \<Phi>2_def)
            qed
            then have BOX2_disj: "pairwise (\<lambda>x y. negligible (BOX2 (\<eta> x) x \<inter> BOX2 (\<eta> y) y)) (tag ` \<G>)"
              by (simp add: pairwise_imageI)
            then have BOX_disj: "pairwise (\<lambda>x y. negligible (BOX (\<eta> x) x \<inter> BOX (\<eta> y) y)) (tag ` \<G>)"
            proof (rule pairwise_mono)
              show "negligible (BOX (\<eta> x) x \<inter> BOX (\<eta> y) y)"
                if "negligible (BOX2 (\<eta> x) x \<inter> BOX2 (\<eta> y) y)" for x y
                by (metis (no_types, hide_lams) that Int_mono negligible_subset BOX_sub)
            qed auto

            have eq: "\<And>box. (\<lambda>D. box (\<eta> (tag D)) (tag D)) ` \<G> = (\<lambda>t. box (\<eta> t) t) ` tag ` \<G>"
              by (simp add: image_comp)
            have "measure lebesgue (BOX2 (\<eta> t) t) * 3 ^ DIM('a)
                = measure lebesgue (BOX (\<eta> t) t) * (2*3) ^ DIM('a)"
              if "t \<in> tag ` \<G>" for t
            proof -
              have "content (cbox (t - \<eta> t *\<^sub>R One) (t + \<eta> t *\<^sub>R One))
                  = content (cbox t (t + \<eta> t *\<^sub>R One)) * 2 ^ DIM('a)"
                using that by (simp add: algebra_simps content_cbox_if box_eq_empty)
              then show ?thesis
                by (simp add: BOX2_def BOX_def flip: power_mult_distrib)
            qed
            then have "measure lebesgue (\<Union>(\<Phi>2 ` \<G>)) * 3 ^ DIM('a) = measure lebesgue (\<Union>(\<Phi> ` \<G>)) * 6 ^ DIM('a)"
              unfolding \<Phi>_def \<Phi>2_def eq
              by (simp add: measure_negligible_finite_Union_image
                  \<open>finite \<G>\<close> BOX2_m BOX_m BOX2_disj BOX_disj sum_distrib_right
                  del: UN_simps)
            also have "\<dots> \<le> e/2"
            proof -
              have "\<mu> * measure lebesgue (\<Union>D\<in>\<G>. \<Phi> D) \<le> \<mu> * (\<Sum>D \<in> \<Phi>`\<G>. measure lebesgue D)"
                using \<open>\<mu> > 0\<close> \<open>finite \<G>\<close> by (force simp: BOX_m \<Phi>_def fmeasurableD intro: measure_Union_le)
              also have "\<dots> = (\<Sum>D \<in> \<Phi>`\<G>. measure lebesgue D * \<mu>)"
                by (metis mult.commute sum_distrib_right)
              also have "\<dots> \<le> (\<Sum>(x, K) \<in> (\<lambda>D. (tag D, \<Phi> D)) ` \<G>.  norm (content K *\<^sub>R f x - integral K f))"
              proof (rule sum_le_included; clarify?)
                fix D
                assume "D \<in> \<G>"
                then have "\<eta> (tag D) > 0"
                  using \<open>\<F> \<subseteq> \<D>\<close> \<open>\<G> \<subseteq> \<F>\<close> h0 tag_in_E by auto
                then have m_\<Phi>: "measure lebesgue (\<Phi> D) > 0"
                  by (simp add: \<Phi>_def BOX_def algebra_simps)
                have "\<mu> \<le> norm (i (\<eta>(tag D)) (tag D) - f(tag D))"
                  using \<mu>_le \<open>D \<in> \<G>\<close> \<open>\<F> \<subseteq> \<D>\<close> \<open>\<G> \<subseteq> \<F>\<close> tag_in_E by auto
                also have "\<dots> = norm ((content (\<Phi> D) *\<^sub>R f(tag D) - integral (\<Phi> D) f) /\<^sub>R measure lebesgue (\<Phi> D))"
                  using m_\<Phi>
                  unfolding i_def \<Phi>_def BOX_def
                  by (simp add: algebra_simps content_cbox_plus norm_minus_commute)
                finally have "measure lebesgue (\<Phi> D) * \<mu> \<le> norm (content (\<Phi> D) *\<^sub>R f(tag D) - integral (\<Phi> D) f)"
                  using m_\<Phi> by (simp add: field_simps)
                then show "\<exists>y\<in>(\<lambda>D. (tag D, \<Phi> D)) ` \<G>.
                        snd y = \<Phi> D \<and> measure lebesgue (\<Phi> D) * \<mu> \<le> (case y of (x, k) \<Rightarrow> norm (content k *\<^sub>R f x - integral k f))"
                  using \<open>D \<in> \<G>\<close> by auto
              qed (use \<open>finite \<G>\<close> in auto)
              also have "\<dots> < ?ee"
              proof (rule \<gamma>)
                show "(\<lambda>D. (tag D, \<Phi> D)) ` \<G> tagged_partial_division_of cbox (a - One) (b + One)"
                  unfolding tagged_partial_division_of_def
                proof (intro conjI allI impI ; clarify ?)
                  show "tag D \<in> \<Phi> D"
                    if "D \<in> \<G>" for D
                    using that \<open>\<F> \<subseteq> \<D>\<close> \<open>\<G> \<subseteq> \<F>\<close> h0 tag_in_E
                    by (auto simp: \<Phi>_def BOX_def mem_box algebra_simps eucl_less_le_not_le in_mono)
                  show "y \<in> cbox (a - One) (b + One)" if "D \<in> \<G>" "y \<in> \<Phi> D" for D y
                    using that BOX_cbox \<Phi>_def \<open>\<F> \<subseteq> \<D>\<close> \<open>\<G> \<subseteq> \<F>\<close> tag_in_E by blast
                  show "tag D = tag E \<and> \<Phi> D = \<Phi> E"
                    if "D \<in> \<G>" "E \<in> \<G>" and ne: "interior (\<Phi> D) \<inter> interior (\<Phi> E) \<noteq> {}" for D E
                  proof -
                    have "BOX2 (\<eta> (tag D)) (tag D) \<inter> BOX2 (\<eta> (tag E)) (tag E) = {} \<or> tag E = tag D"
                      using DISJ2 \<open>D \<in> \<G>\<close> \<open>E \<in> \<G>\<close> by force
                    then have "BOX (\<eta> (tag D)) (tag D) \<inter> BOX (\<eta> (tag E)) (tag E) = {} \<or> tag E = tag D"
                      using BOX_sub by blast
                    then show "tag D = tag E \<and> \<Phi> D = \<Phi> E"
                      by (metis \<Phi>_def interior_Int interior_empty ne)
                  qed
                qed (use \<open>finite \<G>\<close> \<Phi>_def BOX_def in auto)
                show "\<gamma> fine (\<lambda>D. (tag D, \<Phi> D)) ` \<G>"
                  unfolding fine_def \<Phi>_def using BOX_\<gamma> \<open>\<F> \<subseteq> \<D>\<close> \<open>\<G> \<subseteq> \<F>\<close> tag_in_E by blast
              qed
              finally show ?thesis
                using \<open>\<mu> > 0\<close> by (auto simp: divide_simps)
          qed
            finally show ?thesis .
          qed
          moreover
          have "measure lebesgue (\<Union>\<F>) \<le> measure lebesgue (\<Union>(\<Phi>2`\<F>))"
          proof (rule measure_mono_fmeasurable)
            have "D \<subseteq> ball (tag D) (\<eta>(tag D))" if "D \<in> \<F>" for D
              using \<open>\<F> \<subseteq> \<D>\<close> sub_ball_tag that by blast
            moreover have "ball (tag D) (\<eta>(tag D)) \<subseteq> BOX2 (\<eta> (tag D)) (tag D)" if "D \<in> \<F>" for D
            proof (clarsimp simp: \<Phi>2_def BOX2_def mem_box algebra_simps dist_norm)
              fix x and i::'a
              assume "norm (tag D - x) < \<eta> (tag D)" and "i \<in> Basis"
              then have "\<bar>tag D \<bullet> i - x \<bullet> i\<bar> \<le> \<eta> (tag D)"
                by (metis eucl_less_le_not_le inner_commute inner_diff_right norm_bound_Basis_le)
              then show "tag D \<bullet> i \<le> x \<bullet> i + \<eta> (tag D) \<and> x \<bullet> i \<le> \<eta> (tag D) + tag D \<bullet> i"
                by (simp add: abs_diff_le_iff)
            qed
            ultimately show "\<Union>\<F> \<subseteq> \<Union>(\<Phi>2`\<F>)"
              by (force simp: \<Phi>2_def)
            show "\<Union>\<F> \<in> sets lebesgue"
              using \<open>finite \<F>\<close> \<open>\<D> \<subseteq> sets lebesgue\<close> \<open>\<F> \<subseteq> \<D>\<close> by blast
            show "\<Union>(\<Phi>2`\<F>) \<in> lmeasurable"
              unfolding \<Phi>2_def BOX2_def using \<open>finite \<F>\<close> by blast
          qed
          ultimately
          have "measure lebesgue (\<Union>\<F>) \<le> e/2"
            by (auto simp: divide_simps)
          then show "measure lebesgue (\<Union>\<D>) \<le> e"
            using \<F> by linarith
        qed
      qed
    qed
    then have "\<And>j. negligible {x. \<Psi> x (inverse(real j + 1))}"
      using negligible_on_intervals
      by (metis (full_types) inverse_positive_iff_positive le_add_same_cancel1 linorder_not_le nat_le_real_less not_add_less1 of_nat_0)
    then have "negligible ?M"
      by auto
    moreover have "?N \<subseteq> ?M"
    proof (clarsimp simp: dist_norm)
      fix y e
      assume "0 < e"
        and ye [rule_format]: "\<Psi> y e"
      then obtain k where k: "0 < k" "inverse (real k + 1) < e"
        by (metis One_nat_def add.commute less_add_same_cancel2 less_imp_inverse_less less_trans neq0_conv of_nat_1 of_nat_Suc reals_Archimedean zero_less_one)
      with ye show "\<exists>n. \<Psi> y (inverse (real n + 1))"
        apply (rule_tac x=k in exI)
        unfolding \<Psi>_def
        by (force intro: less_le_trans)
    qed
    ultimately show "negligible ?N"
      by (blast intro: negligible_subset)
    show "\<not> \<Psi> x e" if "x \<notin> ?N \<and> 0 < e" for x e
      using that by blast
  qed
  with that show ?thesis
    unfolding i_def BOX_def \<Psi>_def by (fastforce simp add: not_le)
qed



subsection\<open>HOL Light measurability\<close>

lemma measurable_on_UNIV:
  "(\<lambda>x.  if x \<in> S then f x else 0) measurable_on UNIV \<longleftrightarrow> f measurable_on S"
  by (auto simp: measurable_on_def)

lemma measurable_on_spike_set:
  assumes f: "f measurable_on S" and neg: "negligible ((S - T) \<union> (T - S))"
  shows "f measurable_on T"
proof -
  obtain N and F
    where N: "negligible N"
      and conF: "\<And>n. continuous_on UNIV (F n)"
      and tendsF: "\<And>x. x \<notin> N \<Longrightarrow> (\<lambda>n. F n x) \<longlonglongrightarrow> (if x \<in> S then f x else 0)"
    using f by (auto simp: measurable_on_def)
  show ?thesis
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "continuous_on UNIV (\<lambda>x. F n x)" for n
      by (intro conF continuous_intros)
    show "negligible (N \<union> (S - T) \<union> (T - S))"
      by (metis (full_types) N neg negligible_Un_eq)
    show "(\<lambda>n. F n x) \<longlonglongrightarrow> (if x \<in> T then f x else 0)"
      if "x \<notin> (N \<union> (S - T) \<union> (T - S))" for x
      using that tendsF [of x] by auto
  qed
qed

text\<open> Various common equivalent forms of function measurability.                \<close>

lemma measurable_on_0 [simp]: "(\<lambda>x. 0) measurable_on S"
  unfolding measurable_on_def
proof (intro exI conjI allI impI)
  show "(\<lambda>n. 0) \<longlonglongrightarrow> (if x \<in> S then 0::'b else 0)" for x
    by force
qed auto

lemma measurable_on_scaleR_const:
  assumes f: "f measurable_on S"
  shows "(\<lambda>x. c *\<^sub>R f x) measurable_on S"
proof -
  obtain NF and F
    where NF: "negligible NF"
      and conF: "\<And>n. continuous_on UNIV (F n)"
      and tendsF: "\<And>x. x \<notin> NF \<Longrightarrow> (\<lambda>n. F n x) \<longlonglongrightarrow> (if x \<in> S then f x else 0)"
    using f by (auto simp: measurable_on_def)
  show ?thesis
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "continuous_on UNIV (\<lambda>x. c *\<^sub>R F n x)" for n
      by (intro conF continuous_intros)
    show "(\<lambda>n. c *\<^sub>R F n x) \<longlonglongrightarrow> (if x \<in> S then c *\<^sub>R f x else 0)"
      if "x \<notin> NF" for x
      using tendsto_scaleR [OF tendsto_const tendsF, of x] that by auto
  qed (auto simp: NF)
qed


lemma measurable_on_cmul:
  fixes c :: real
  assumes "f measurable_on S"
  shows "(\<lambda>x. c * f x) measurable_on S"
  using measurable_on_scaleR_const [OF assms] by simp

lemma measurable_on_cdivide:
  fixes c :: real
  assumes "f measurable_on S"
  shows "(\<lambda>x. f x / c) measurable_on S"
proof (cases "c=0")
  case False
  then show ?thesis
    using measurable_on_cmul [of f S "1/c"]
    by (simp add: assms)
qed auto


lemma measurable_on_minus:
   "f measurable_on S \<Longrightarrow> (\<lambda>x. -(f x)) measurable_on S"
  using measurable_on_scaleR_const [of f S "-1"] by auto


lemma continuous_imp_measurable_on:
   "continuous_on UNIV f \<Longrightarrow> f measurable_on UNIV"
  unfolding measurable_on_def
  apply (rule_tac x="{}" in exI)
  apply (rule_tac x="\<lambda>n. f" in exI, auto)
  done

proposition integrable_subintervals_imp_measurable:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "\<And>a b. f integrable_on cbox a b"
  shows "f measurable_on UNIV"
proof -
  define BOX where "BOX \<equiv> \<lambda>h. \<lambda>x::'a. cbox x (x + h *\<^sub>R One)"
  define i where "i \<equiv> \<lambda>h x. integral (BOX h x) f /\<^sub>R h ^ DIM('a)"
  obtain N where "negligible N"
    and k: "\<And>x e. \<lbrakk>x \<notin> N; 0 < e\<rbrakk>
            \<Longrightarrow> \<exists>d>0. \<forall>h. 0 < h \<and> h < d \<longrightarrow>
                  norm (integral (cbox x (x + h *\<^sub>R One)) f /\<^sub>R h ^ DIM('a) - f x) < e"
    using integrable_ccontinuous_explicit assms by blast
  show ?thesis
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "continuous_on UNIV ((\<lambda>n x. i (inverse(Suc n)) x) n)" for n
    proof (clarsimp simp: continuous_on_iff)
      show "\<exists>d>0. \<forall>x'. dist x' x < d \<longrightarrow> dist (i (inverse (1 + real n)) x') (i (inverse (1 + real n)) x) < e"
        if "0 < e"
        for x e
      proof -
        let ?e = "e / (1 + real n) ^ DIM('a)"
        have "?e > 0"
          using \<open>e > 0\<close> by auto
        moreover have "x \<in> cbox (x - 2 *\<^sub>R One) (x + 2 *\<^sub>R One)"
          by (simp add: mem_box inner_diff_left inner_left_distrib)
        moreover have "x + One /\<^sub>R real (Suc n) \<in> cbox (x - 2 *\<^sub>R One) (x + 2 *\<^sub>R One)"
          by (auto simp: mem_box inner_diff_left inner_left_distrib field_simps)
        ultimately obtain \<delta> where "\<delta> > 0"
          and \<delta>: "\<And>c' d'. \<lbrakk>c' \<in> cbox (x - 2 *\<^sub>R One) (x + 2 *\<^sub>R One);
                           d' \<in> cbox (x - 2 *\<^sub>R One) (x + 2 *\<^sub>R One);
                           norm(c' - x) \<le> \<delta>; norm(d' - (x + One /\<^sub>R Suc n)) \<le> \<delta>\<rbrakk>
                          \<Longrightarrow> norm(integral(cbox c' d') f - integral(cbox x (x + One /\<^sub>R Suc n)) f) < ?e"
          by (blast intro: indefinite_integral_continuous [of f _ _ x] assms)
        show ?thesis
        proof (intro exI impI conjI allI)
          show "min \<delta> 1 > 0"
            using \<open>\<delta> > 0\<close> by auto
          show "dist (i (inverse (1 + real n)) y) (i (inverse (1 + real n)) x) < e"
            if "dist y x < min \<delta> 1" for y
          proof -
            have no: "norm (y - x) < 1"
              using that by (auto simp: dist_norm)
            have le1: "inverse (1 + real n) \<le> 1"
              by (auto simp: divide_simps)
            have "norm (integral (cbox y (y + One /\<^sub>R real (Suc n))) f
                - integral (cbox x (x + One /\<^sub>R real (Suc n))) f)
                < e / (1 + real n) ^ DIM('a)"
            proof (rule \<delta>)
              show "y \<in> cbox (x - 2 *\<^sub>R One) (x + 2 *\<^sub>R One)"
                using no by (auto simp: mem_box algebra_simps dest: Basis_le_norm [of _ "y-x"])
              show "y + One /\<^sub>R real (Suc n) \<in> cbox (x - 2 *\<^sub>R One) (x + 2 *\<^sub>R One)"
              proof (simp add: dist_norm mem_box algebra_simps, intro ballI conjI)
                fix i::'a
                assume "i \<in> Basis"
                then have 1: "\<bar>y \<bullet> i - x \<bullet> i\<bar> < 1"
                  by (metis inner_commute inner_diff_right no norm_bound_Basis_lt)
                moreover have "\<dots> < (2 + inverse (1 + real n))" "1 \<le> 2 - inverse (1 + real n)"
                  by (auto simp: field_simps)
                ultimately show "x \<bullet> i \<le> y \<bullet> i + (2 + inverse (1 + real n))"
                                "y \<bullet> i + inverse (1 + real n) \<le> x \<bullet> i + 2"
                  by linarith+
              qed
              show "norm (y - x) \<le> \<delta>" "norm (y + One /\<^sub>R real (Suc n) - (x + One /\<^sub>R real (Suc n))) \<le> \<delta>"
                using that by (auto simp: dist_norm)
            qed
            then show ?thesis
              using that by (simp add: dist_norm i_def BOX_def field_simps flip: scaleR_diff_right)
          qed
        qed
      qed
    qed
    show "negligible N"
      by (simp add: \<open>negligible N\<close>)
    show "(\<lambda>n. i (inverse (Suc n)) x) \<longlonglongrightarrow> (if x \<in> UNIV then f x else 0)"
      if "x \<notin> N" for x
      unfolding lim_sequentially
    proof clarsimp
      show "\<exists>no. \<forall>n\<ge>no. dist (i (inverse (1 + real n)) x) (f x) < e"
        if "0 < e" for e
      proof -
        obtain d where "d > 0"
          and d: "\<And>h. \<lbrakk>0 < h; h < d\<rbrakk> \<Longrightarrow>
              norm (integral (cbox x (x + h *\<^sub>R One)) f /\<^sub>R h ^ DIM('a) - f x) < e"
          using k [of x e] \<open>x \<notin> N\<close> \<open>0 < e\<close> by blast
        then obtain M where M: "M \<noteq> 0" "0 < inverse (real M)" "inverse (real M) < d"
          using real_arch_invD by auto
        show ?thesis
        proof (intro exI allI impI)
          show "dist (i (inverse (1 + real n)) x) (f x) < e"
            if "M \<le> n" for n
          proof -
            have *: "0 < inverse (1 + real n)" "inverse (1 + real n) \<le> inverse M"
              using that \<open>M \<noteq> 0\<close> by auto
            show ?thesis
              using that M
              apply (simp add: i_def BOX_def dist_norm)
              apply (blast intro: le_less_trans * d)
              done
          qed
        qed
      qed
    qed
  qed
qed

subsection\<open>Composing continuous and measurable functions; a few variants\<close>

lemma measurable_on_compose_continuous:
   assumes f: "f measurable_on UNIV" and g: "continuous_on UNIV g"
   shows "(g \<circ> f) measurable_on UNIV"
proof -
  obtain N and F
    where "negligible N"
      and conF: "\<And>n. continuous_on UNIV (F n)"
      and tendsF: "\<And>x. x \<notin> N \<Longrightarrow> (\<lambda>n. F n x) \<longlonglongrightarrow> f x"
    using f by (auto simp: measurable_on_def)
  show ?thesis
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "negligible N"
      by fact
    show "continuous_on UNIV (g \<circ> (F n))" for n
      using conF continuous_on_compose continuous_on_subset g by blast
    show "(\<lambda>n. (g \<circ> F n) x) \<longlonglongrightarrow> (if x \<in> UNIV then (g \<circ> f) x else 0)"
      if "x \<notin> N" for x :: 'a
      using that g tendsF by (auto simp: continuous_on_def intro: tendsto_compose)
  qed
qed

lemma measurable_on_compose_continuous_0:
   assumes f: "f measurable_on S" and g: "continuous_on UNIV g" and "g 0 = 0"
   shows "(g \<circ> f) measurable_on S"
proof -
  have f': "(\<lambda>x. if x \<in> S then f x else 0) measurable_on UNIV"
    using f measurable_on_UNIV by blast
  show ?thesis
    using measurable_on_compose_continuous [OF f' g]
    by (simp add: measurable_on_UNIV o_def if_distrib \<open>g 0 = 0\<close> cong: if_cong)
qed


lemma measurable_on_compose_continuous_box:
  assumes fm: "f measurable_on UNIV" and fab: "\<And>x. f x \<in> box a b"
    and contg: "continuous_on (box a b) g"
  shows "(g \<circ> f) measurable_on UNIV"
proof -
  have "\<exists>\<gamma>. (\<forall>n. continuous_on UNIV (\<gamma> n)) \<and> (\<forall>x. x \<notin> N \<longrightarrow> (\<lambda>n. \<gamma> n x) \<longlonglongrightarrow> g (f x))"
    if "negligible N"
      and conth [rule_format]: "\<forall>n. continuous_on UNIV (\<lambda>x. h n x)"
      and tends [rule_format]: "\<forall>x. x \<notin> N \<longrightarrow> (\<lambda>n. h n x) \<longlonglongrightarrow> f x"
    for N and h :: "nat \<Rightarrow> 'a \<Rightarrow> 'b"
  proof -
    define \<theta> where "\<theta> \<equiv> \<lambda>n x. (\<Sum>i\<in>Basis. (max (a\<bullet>i + (b\<bullet>i - a\<bullet>i) / real (n+2))
                                            (min ((h n x)\<bullet>i)
                                                 (b\<bullet>i - (b\<bullet>i - a\<bullet>i) / real (n+2)))) *\<^sub>R i)"
    have aibi: "\<And>i. i \<in> Basis \<Longrightarrow> a \<bullet> i < b \<bullet> i"
      using box_ne_empty(2) fab by auto
    then have *: "\<And>i n. i \<in> Basis \<Longrightarrow> a \<bullet> i + real n * (a \<bullet> i) < b \<bullet> i + real n * (b \<bullet> i)"
      by (meson add_mono_thms_linordered_field(3) less_eq_real_def mult_left_mono of_nat_0_le_iff)
    show ?thesis
    proof (intro exI conjI allI impI)
      show "continuous_on UNIV (g \<circ> (\<theta> n))" for n :: nat
        unfolding \<theta>_def
        apply (intro continuous_on_compose2 [OF contg] continuous_intros conth)
         apply (auto simp: aibi * mem_box less_max_iff_disj min_less_iff_disj algebra_simps divide_simps)
        done
      show "(\<lambda>n. (g \<circ> \<theta> n) x) \<longlonglongrightarrow> g (f x)"
        if "x \<notin> N" for x
        unfolding o_def
      proof (rule isCont_tendsto_compose [where g=g])
        show "isCont g (f x)"
          using contg fab continuous_on_eq_continuous_at by blast
        have "(\<lambda>n. \<theta> n x) \<longlonglongrightarrow> (\<Sum>i\<in>Basis. max (a \<bullet> i) (min (f x \<bullet> i) (b \<bullet> i)) *\<^sub>R i)"
          unfolding \<theta>_def
        proof (intro tendsto_intros \<open>x \<notin> N\<close> tends)
          fix i::'b
          assume "i \<in> Basis"
          have a: "(\<lambda>n. a \<bullet> i + (b \<bullet> i - a \<bullet> i) / real n) \<longlonglongrightarrow> a\<bullet>i + 0"
            by (intro tendsto_add lim_const_over_n tendsto_const)
          show "(\<lambda>n. a \<bullet> i + (b \<bullet> i - a \<bullet> i) / real (n + 2)) \<longlonglongrightarrow> a \<bullet> i"
            using LIMSEQ_ignore_initial_segment [where k=2, OF a] by simp
          have b: "(\<lambda>n. b\<bullet>i - (b \<bullet> i - a \<bullet> i) / (real n)) \<longlonglongrightarrow> b\<bullet>i - 0"
            by (intro tendsto_diff lim_const_over_n tendsto_const)
          show "(\<lambda>n. b \<bullet> i - (b \<bullet> i - a \<bullet> i) / real (n + 2)) \<longlonglongrightarrow> b \<bullet> i"
            using LIMSEQ_ignore_initial_segment [where k=2, OF b] by simp
        qed
        also have "(\<Sum>i\<in>Basis. max (a \<bullet> i) (min (f x \<bullet> i) (b \<bullet> i)) *\<^sub>R i) = (\<Sum>i\<in>Basis. (f x \<bullet> i) *\<^sub>R i)"
          apply (rule sum.cong)
          using fab
           apply auto
          apply (intro order_antisym)
           apply (auto simp: mem_box)
          using less_imp_le apply blast
          by (metis (full_types) linear max_less_iff_conj min.bounded_iff not_le)
        also have "\<dots> = f x"
          using euclidean_representation by blast
        finally show "(\<lambda>n. \<theta> n x) \<longlonglongrightarrow> f x" .
      qed
    qed
  qed
  then show ?thesis
    using fm by (auto simp: measurable_on_def)
qed

lemma measurable_on_Pair:
  assumes f: "f measurable_on S" and g: "g measurable_on S"
  shows "(\<lambda>x. (f x, g x)) measurable_on S"
proof -
  obtain NF and F
    where NF: "negligible NF"
      and conF: "\<And>n. continuous_on UNIV (F n)"
      and tendsF: "\<And>x. x \<notin> NF \<Longrightarrow> (\<lambda>n. F n x) \<longlonglongrightarrow> (if x \<in> S then f x else 0)"
    using f by (auto simp: measurable_on_def)
  obtain NG and G
    where NG: "negligible NG"
      and conG: "\<And>n. continuous_on UNIV (G n)"
      and tendsG: "\<And>x. x \<notin> NG \<Longrightarrow> (\<lambda>n. G n x) \<longlonglongrightarrow> (if x \<in> S then g x else 0)"
    using g by (auto simp: measurable_on_def)
  show ?thesis
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "negligible (NF \<union> NG)"
      by (simp add: NF NG)
    show "continuous_on UNIV (\<lambda>x. (F n x, G n x))" for n
      using conF conG continuous_on_Pair by blast
    show "(\<lambda>n. (F n x, G n x)) \<longlonglongrightarrow> (if x \<in> S then (f x, g x) else 0)"
      if "x \<notin> NF \<union> NG" for x
      using tendsto_Pair [OF tendsF tendsG, of x x] that unfolding zero_prod_def
      by (simp add: split: if_split_asm)
  qed
qed

lemma measurable_on_combine:
  assumes f: "f measurable_on S" and g: "g measurable_on S"
    and h: "continuous_on UNIV (\<lambda>x. h (fst x) (snd x))" and "h 0 0 = 0"
  shows "(\<lambda>x. h (f x) (g x)) measurable_on S"
proof -
  have *: "(\<lambda>x. h (f x) (g x)) = (\<lambda>x. h (fst x) (snd x)) \<circ> (\<lambda>x. (f x, g x))"
    by auto
  show ?thesis
    unfolding * by (auto simp: measurable_on_compose_continuous_0 measurable_on_Pair assms)
qed

lemma measurable_on_add:
  assumes f: "f measurable_on S" and g: "g measurable_on S"
  shows "(\<lambda>x. f x + g x) measurable_on S"
  by (intro continuous_intros measurable_on_combine [OF assms]) auto

lemma measurable_on_diff:
  assumes f: "f measurable_on S" and g: "g measurable_on S"
  shows "(\<lambda>x. f x - g x) measurable_on S"
  by (intro continuous_intros measurable_on_combine [OF assms]) auto

lemma measurable_on_scaleR:
  assumes f: "f measurable_on S" and g: "g measurable_on S"
  shows "(\<lambda>x. f x *\<^sub>R g x) measurable_on S"
  by (intro continuous_intros measurable_on_combine [OF assms]) auto

lemma measurable_on_sum:
  assumes "finite I" "\<And>i. i \<in> I \<Longrightarrow> f i measurable_on S"
  shows "(\<lambda>x. sum  (\<lambda>i. f i x) I) measurable_on S"
  using assms by (induction I) (auto simp: measurable_on_add)

lemma measurable_on_spike:
  assumes f: "f measurable_on T" and "negligible S" and gf: "\<And>x. x \<in> T - S \<Longrightarrow> g x = f x"
  shows "g measurable_on T"
proof -
  obtain NF and F
    where NF: "negligible NF"
      and conF: "\<And>n. continuous_on UNIV (F n)"
      and tendsF: "\<And>x. x \<notin> NF \<Longrightarrow> (\<lambda>n. F n x) \<longlonglongrightarrow> (if x \<in> T then f x else 0)"
    using f by (auto simp: measurable_on_def)
  show ?thesis
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "negligible (NF \<union> S)"
      by (simp add: NF \<open>negligible S\<close>)
    show "\<And>x. x \<notin> NF \<union> S \<Longrightarrow> (\<lambda>n. F n x) \<longlonglongrightarrow> (if x \<in> T then g x else 0)"
      by (metis (full_types) Diff_iff Un_iff gf tendsF)
  qed (auto simp: conF)
qed


lemma measurable_on_preimage_lemma0:
  fixes f :: "'a::euclidean_space \<Rightarrow> real"
  assumes "m \<in> \<int>" and f: "m / 2^n \<le> (f x)" "(f x) < (m+1) / 2^n" and m: "\<bar>m\<bar> \<le> 2^(2 * n)"
  shows "(\<Sum>k\<in>{k \<in> \<int>. \<bar>k\<bar> \<le> 2^(2 * n)}.
             (k / 2^n) * indicator {y. k / 2^n \<le> f y \<and> f y < (k+1) / 2^n} x)
       = (m / 2^n)"  (is "?lhs = ?rhs")
proof -
  have "?lhs = (\<Sum>k\<in>{m}. (k / 2^n) * indicator {y. k / 2^n \<le> f y \<and> f y < (k+1) / 2^n} x)"
  proof (intro sum.mono_neutral_right ballI)
    show "finite {k::real. k \<in> \<int> \<and> \<bar>k\<bar> \<le> 2^(2 * n)}"
      using finite_abs_int_segment by blast
    show "(i / 2^n) * indicat_real {y. i / 2^n \<le> f y \<and> f y < (i+1) / 2^n} x = 0"
      if "i \<in> {N \<in> \<int>. \<bar>N\<bar> \<le> 2^(2 * n)} - {m}" for i
      using f m \<open>m \<in> \<int>\<close> that Ints_eq_abs_less1 [of i m]
      by (auto simp: indicator_def divide_simps)
  qed (auto simp: assms)
  also have "\<dots> = ?rhs"
    using assms by (auto simp: indicator_def)
  finally show ?thesis .
qed

(*see HOL Light's lebesgue_measurable BUT OUR lmeasurable IS NOT THE SAME. It's more like "sets lebesgue"
 `lebesgue_measurable s <=> (indicator s) measurable_on (:real^N)`;;
*)

proposition indicator_measurable_on:
  assumes "S \<in> sets lebesgue"
  shows "indicat_real S measurable_on UNIV"
proof -
  { fix n::nat
    let ?\<epsilon> = "(1::real) / (2 * 2^n)"
    have \<epsilon>: "?\<epsilon> > 0"
      by auto
    obtain T where "closed T" "T \<subseteq> S" "S-T \<in> lmeasurable" and ST: "emeasure lebesgue (S - T) < ?\<epsilon>"
      by (meson \<epsilon> assms sets_lebesgue_inner_closed)
    obtain U where "open U" "S \<subseteq> U" "(U - S) \<in> lmeasurable" and US: "emeasure lebesgue (U - S) < ?\<epsilon>"
      by (meson \<epsilon> assms sets_lebesgue_outer_open)
    have eq: "-T \<inter> U = (S-T) \<union> (U - S)"
      using \<open>T \<subseteq> S\<close> \<open>S \<subseteq> U\<close> by auto
    have "emeasure lebesgue ((S-T) \<union> (U - S)) \<le> emeasure lebesgue (S - T) + emeasure lebesgue (U - S)"
      using \<open>S - T \<in> lmeasurable\<close> \<open>U - S \<in> lmeasurable\<close> emeasure_subadditive by blast
    also have "\<dots> < ?\<epsilon> + ?\<epsilon>"
      using ST US add_mono_ennreal by metis
    finally have le: "emeasure lebesgue (-T \<inter> U) < ennreal (1 / 2^n)"
      by (simp add: eq)
    have 1: "continuous_on (T \<union> -U) (indicat_real S)"
      unfolding indicator_def
    proof (rule continuous_on_cases [OF \<open>closed T\<close>])
      show "closed (- U)"
        using \<open>open U\<close> by blast
      show "continuous_on T (\<lambda>x. 1::real)" "continuous_on (- U) (\<lambda>x. 0::real)"
        by (auto simp: continuous_on)
      show "\<forall>x. x \<in> T \<and> x \<notin> S \<or> x \<in> - U \<and> x \<in> S \<longrightarrow> (1::real) = 0"
        using \<open>T \<subseteq> S\<close> \<open>S \<subseteq> U\<close> by auto
    qed
    have 2: "closedin (top_of_set UNIV) (T \<union> -U)"
      using \<open>closed T\<close> \<open>open U\<close> by auto
    obtain g where "continuous_on UNIV g" "\<And>x. x \<in> T \<union> -U \<Longrightarrow> g x = indicat_real S x" "\<And>x. norm(g x) \<le> 1"
      by (rule Tietze [OF 1 2, of 1]) auto
    with le have "\<exists>g E. continuous_on UNIV g \<and> (\<forall>x \<in> -E. g x = indicat_real S x) \<and>
                        (\<forall>x. norm(g x) \<le> 1) \<and> E \<in> sets lebesgue \<and> emeasure lebesgue E < ennreal (1 / 2^n)"
      apply (rule_tac x=g in exI)
      apply (rule_tac x="-T \<inter> U" in exI)
      using \<open>S - T \<in> lmeasurable\<close> \<open>U - S \<in> lmeasurable\<close> eq by auto
  }
  then obtain g E where cont: "\<And>n. continuous_on UNIV (g n)"
    and geq: "\<And>n x. x \<in> - E n \<Longrightarrow> g n x = indicat_real S x"
    and ng1: "\<And>n x. norm(g n x) \<le> 1"
    and Eset: "\<And>n. E n \<in> sets lebesgue"
    and Em: "\<And>n. emeasure lebesgue (E n) < ennreal (1 / 2^n)"
    by metis
  have null: "limsup E \<in> null_sets lebesgue"
  proof (rule borel_cantelli_limsup1 [OF Eset])
    show "emeasure lebesgue (E n) < \<infinity>" for n
      by (metis Em infinity_ennreal_def order.asym top.not_eq_extremum)
    show "summable (\<lambda>n. measure lebesgue (E n))"
    proof (rule summable_comparison_test' [OF summable_geometric, of "1/2" 0])
      show "norm (measure lebesgue (E n)) \<le> (1/2) ^ n"  for n
        using Em [of n] by (simp add: measure_def enn2real_leI power_one_over)
    qed auto
  qed
  have tends: "(\<lambda>n. g n x) \<longlonglongrightarrow> indicat_real S x" if "x \<notin> limsup E" for x
  proof -
    have "\<forall>\<^sub>F n in sequentially. x \<in> - E n"
      using that by (simp add: mem_limsup_iff not_frequently)
    then show ?thesis
      unfolding tendsto_iff dist_real_def
      by (simp add: eventually_mono geq)
  qed
  show ?thesis
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "negligible (limsup E)"
      using negligible_iff_null_sets null by blast
    show "continuous_on UNIV (g n)" for n
      using cont by blast
  qed (use tends in auto)
qed

lemma measurable_on_restrict:
  assumes f: "f measurable_on UNIV" and S: "S \<in> sets lebesgue"
  shows "(\<lambda>x. if x \<in> S then f x else 0) measurable_on UNIV"
proof -
  have "indicat_real S measurable_on UNIV"
    by (simp add: S indicator_measurable_on)
  then show ?thesis
    using measurable_on_scaleR [OF _ f, of "indicat_real S"]
    by (simp add: indicator_scaleR_eq_if)
qed

lemma measurable_on_const_UNIV: "(\<lambda>x. k) measurable_on UNIV"
  by (simp add: continuous_imp_measurable_on)

lemma measurable_on_const [simp]: "S \<in> sets lebesgue \<Longrightarrow> (\<lambda>x. k) measurable_on S"
  using measurable_on_UNIV measurable_on_const_UNIV measurable_on_restrict by blast

lemma simple_function_indicator_representation_real:
  fixes f ::"'a \<Rightarrow> real"
  assumes f: "simple_function M f" and x: "x \<in> space M" and nn: "\<And>x. f x \<ge> 0"
  shows "f x = (\<Sum>y \<in> f ` space M. y * indicator (f -` {y} \<inter> space M) x)"
proof -
  have f': "simple_function M (ennreal \<circ> f)"
    by (simp add: f)
  have *: "f x =
     enn2real
      (\<Sum>y\<in> ennreal ` f ` space M.
         y * indicator ((ennreal \<circ> f) -` {y} \<inter> space M) x)"
    using arg_cong [OF simple_function_indicator_representation [OF f' x], of enn2real, simplified nn o_def] nn
    unfolding o_def image_comp
    by (metis enn2real_ennreal)
  have "enn2real (\<Sum>y\<in>ennreal ` f ` space M. if ennreal (f x) = y \<and> x \<in> space M then y else 0)
      = sum (enn2real \<circ> (\<lambda>y. if ennreal (f x) = y \<and> x \<in> space M then y else 0))
            (ennreal ` f ` space M)"
    by (rule enn2real_sum) auto
  also have "\<dots> = sum (enn2real \<circ> (\<lambda>y. if ennreal (f x) = y \<and> x \<in> space M then y else 0) \<circ> ennreal)
                   (f ` space M)"
    by (rule sum.reindex) (use nn in \<open>auto simp: inj_on_def intro: sum.cong\<close>)
  also have "\<dots> = (\<Sum>y\<in>f ` space M. if f x = y \<and> x \<in> space M then y else 0)"
    using nn
    by (auto simp: inj_on_def intro: sum.cong)
  finally show ?thesis
    by (subst *) (simp add: enn2real_sum indicator_def if_distrib cong: if_cong)
qed

lemma\<^marker>\<open>tag important\<close> simple_function_induct_real
    [consumes 1, case_names cong set mult add, induct set: simple_function]:
  fixes u :: "'a \<Rightarrow> real"
  assumes u: "simple_function M u"
  assumes cong: "\<And>f g. simple_function M f \<Longrightarrow> simple_function M g \<Longrightarrow> (AE x in M. f x = g x) \<Longrightarrow> P f \<Longrightarrow> P g"
  assumes set: "\<And>A. A \<in> sets M \<Longrightarrow> P (indicator A)"
  assumes mult: "\<And>u c. P u \<Longrightarrow> P (\<lambda>x. c * u x)"
  assumes add: "\<And>u v. P u \<Longrightarrow> P v \<Longrightarrow> P (\<lambda>x. u x + v x)"
  and nn: "\<And>x. u x \<ge> 0"
  shows "P u"
proof (rule cong)
  from AE_space show "AE x in M. (\<Sum>y\<in>u ` space M. y * indicator (u -` {y} \<inter> space M) x) = u x"
  proof eventually_elim
    fix x assume x: "x \<in> space M"
    from simple_function_indicator_representation_real[OF u x] nn
    show "(\<Sum>y\<in>u ` space M. y * indicator (u -` {y} \<inter> space M) x) = u x"
      by metis
  qed
next
  from u have "finite (u ` space M)"
    unfolding simple_function_def by auto
  then show "P (\<lambda>x. \<Sum>y\<in>u ` space M. y * indicator (u -` {y} \<inter> space M) x)"
  proof induct
    case empty
    then show ?case
      using set[of "{}"] by (simp add: indicator_def[abs_def])
  next
    case (insert a F)
    have eq: "\<Sum> {y. u x = y \<and> (y = a \<or> y \<in> F) \<and> x \<in> space M}
            = (if u x = a \<and> x \<in> space M then a else 0) + \<Sum> {y. u x = y \<and> y \<in> F \<and> x \<in> space M}" for x
    proof (cases "x \<in> space M")
      case True
      have *: "{y. u x = y \<and> (y = a \<or> y \<in> F)} = {y. u x = a \<and> y = a} \<union> {y. u x = y \<and> y \<in> F}"
        by auto
      show ?thesis
        using insert by (simp add: * True)
    qed auto
    have a: "P (\<lambda>x. a * indicator (u -` {a} \<inter> space M) x)"
    proof (intro mult set)
      show "u -` {a} \<inter> space M \<in> sets M"
        using u by auto
    qed
    show ?case
      using nn insert a
      by (simp add: eq indicator_times_eq_if [where f = "\<lambda>x. a"] add)
  qed
next
  show "simple_function M (\<lambda>x. (\<Sum>y\<in>u ` space M. y * indicator (u -` {y} \<inter> space M) x))"
    apply (subst simple_function_cong)
    apply (rule simple_function_indicator_representation_real[symmetric])
    apply (auto intro: u nn)
    done
qed fact

proposition simple_function_measurable_on_UNIV:
  fixes f :: "'a::euclidean_space \<Rightarrow> real"
  assumes f: "simple_function lebesgue f" and nn: "\<And>x. f x \<ge> 0"
  shows "f measurable_on UNIV"
  using f
proof (induction f)
  case (cong f g)
  then obtain N where "negligible N" "{x. g x \<noteq> f x} \<subseteq> N"
    by (auto simp: eventually_ae_filter_negligible eq_commute)
  then show ?case
    by (blast intro: measurable_on_spike cong)
next
  case (set S)
  then show ?case
    by (simp add: indicator_measurable_on)
next
  case (mult u c)
  then show ?case
    by (simp add: measurable_on_cmul)
  case (add u v)
  then show ?case
    by (simp add: measurable_on_add)
qed (auto simp: nn)

lemma simple_function_lebesgue_if:
  fixes f :: "'a::euclidean_space \<Rightarrow> real"
  assumes f: "simple_function lebesgue f" and S: "S \<in> sets lebesgue"
  shows "simple_function lebesgue (\<lambda>x. if x \<in> S then f x else 0)"
proof -
  have ffin: "finite (range f)" and fsets: "\<forall>x. f -` {f x} \<in> sets lebesgue"
    using f by (auto simp: simple_function_def)
  have "finite (f ` S)"
    by (meson finite_subset subset_image_iff ffin top_greatest)
  moreover have "finite ((\<lambda>x. 0::real) ` T)" for T :: "'a set"
    by (auto simp: image_def)
  moreover have if_sets: "(\<lambda>x. if x \<in> S then f x else 0) -` {f a} \<in> sets lebesgue" for a
  proof -
    have *: "(\<lambda>x. if x \<in> S then f x else 0) -` {f a}
           = (if f a = 0 then -S \<union> f -` {f a} else (f -` {f a}) \<inter> S)"
      by (auto simp: split: if_split_asm)
    show ?thesis
      unfolding * by (metis Compl_in_sets_lebesgue S sets.Int sets.Un fsets)
  qed
  moreover have "(\<lambda>x. if x \<in> S then f x else 0) -` {0} \<in> sets lebesgue"
  proof (cases "0 \<in> range f")
    case True
    then show ?thesis
      by (metis (no_types, lifting) if_sets rangeE)
  next
    case False
    then have "(\<lambda>x. if x \<in> S then f x else 0) -` {0} = -S"
      by auto
    then show ?thesis
      by (simp add: Compl_in_sets_lebesgue S)
  qed
  ultimately show ?thesis
    by (auto simp: simple_function_def)
qed

corollary simple_function_measurable_on:
  fixes f :: "'a::euclidean_space \<Rightarrow> real"
  assumes f: "simple_function lebesgue f" and nn: "\<And>x. f x \<ge> 0" and S: "S \<in> sets lebesgue"
  shows "f measurable_on S"
  by (simp add: measurable_on_UNIV [symmetric, of f] S f simple_function_lebesgue_if nn simple_function_measurable_on_UNIV)

lemma
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::ordered_euclidean_space"
  assumes f: "f measurable_on S" and g: "g measurable_on S"
  shows measurable_on_sup: "(\<lambda>x. f x \<squnion> g x) measurable_on S"
  and   measurable_on_inf: "(\<lambda>x. f x \<sqinter> g x) measurable_on S"
proof -
  obtain NF and F
    where NF: "negligible NF"
      and conF: "\<And>n. continuous_on UNIV (F n)"
      and tendsF: "\<And>x. x \<notin> NF \<Longrightarrow> (\<lambda>n. F n x) \<longlonglongrightarrow> (if x \<in> S then f x else 0)"
    using f by (auto simp: measurable_on_def)
  obtain NG and G
    where NG: "negligible NG"
      and conG: "\<And>n. continuous_on UNIV (G n)"
      and tendsG: "\<And>x. x \<notin> NG \<Longrightarrow> (\<lambda>n. G n x) \<longlonglongrightarrow> (if x \<in> S then g x else 0)"
    using g by (auto simp: measurable_on_def)
  show "(\<lambda>x. f x \<squnion> g x) measurable_on S"
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "continuous_on UNIV (\<lambda>x. F n x \<squnion> G n x)" for n
      unfolding sup_max eucl_sup  by (intro conF conG continuous_intros)
    show "(\<lambda>n. F n x \<squnion> G n x) \<longlonglongrightarrow> (if x \<in> S then f x \<squnion> g x else 0)"
      if "x \<notin> NF \<union> NG" for x
      using tendsto_sup [OF tendsF tendsG, of x x] that by auto
  qed (simp add: NF NG)
  show "(\<lambda>x. f x \<sqinter> g x) measurable_on S"
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "continuous_on UNIV (\<lambda>x. F n x \<sqinter> G n x)" for n
      unfolding inf_min eucl_inf  by (intro conF conG continuous_intros)
    show "(\<lambda>n. F n x \<sqinter> G n x) \<longlonglongrightarrow> (if x \<in> S then f x \<sqinter> g x else 0)"
      if "x \<notin> NF \<union> NG" for x
      using tendsto_inf [OF tendsF tendsG, of x x] that by auto
  qed (simp add: NF NG)
qed

proposition measurable_on_componentwise_UNIV:
  "f measurable_on UNIV \<longleftrightarrow> (\<forall>i\<in>Basis. (\<lambda>x. (f x \<bullet> i) *\<^sub>R i) measurable_on UNIV)"
  (is "?lhs = ?rhs")
proof
  assume L: ?lhs
  show ?rhs
  proof
    fix i::'b
    assume "i \<in> Basis"
    have cont: "continuous_on UNIV (\<lambda>x. (x \<bullet> i) *\<^sub>R i)"
      by (intro continuous_intros)
    show "(\<lambda>x. (f x \<bullet> i) *\<^sub>R i) measurable_on UNIV"
      using measurable_on_compose_continuous [OF L cont]
      by (simp add: o_def)
  qed
next
  assume ?rhs
  then have "\<exists>N g. negligible N \<and>
              (\<forall>n. continuous_on UNIV (g n)) \<and>
              (\<forall>x. x \<notin> N \<longrightarrow> (\<lambda>n. g n x) \<longlonglongrightarrow> (f x \<bullet> i) *\<^sub>R i)"
    if "i \<in> Basis" for i
    by (simp add: measurable_on_def that)
  then obtain N g where N: "\<And>i. i \<in> Basis \<Longrightarrow> negligible (N i)"
        and cont: "\<And>i n. i \<in> Basis \<Longrightarrow> continuous_on UNIV (g i n)"
        and tends: "\<And>i x. \<lbrakk>i \<in> Basis; x \<notin> N i\<rbrakk> \<Longrightarrow> (\<lambda>n. g i n x) \<longlonglongrightarrow> (f x \<bullet> i) *\<^sub>R i"
    by metis
  show ?lhs
    unfolding measurable_on_def
  proof (intro exI conjI allI impI)
    show "negligible (\<Union>i \<in> Basis. N i)"
      using N eucl.finite_Basis by blast
    show "continuous_on UNIV (\<lambda>x. (\<Sum>i\<in>Basis. g i n x))" for n
      by (intro continuous_intros cont)
  next
    fix x
    assume "x \<notin> (\<Union>i \<in> Basis. N i)"
    then have "\<And>i. i \<in> Basis \<Longrightarrow> x \<notin> N i"
      by auto
    then have "(\<lambda>n. (\<Sum>i\<in>Basis. g i n x)) \<longlonglongrightarrow> (\<Sum>i\<in>Basis. (f x \<bullet> i) *\<^sub>R i)"
      by (intro tends tendsto_intros)
    then show "(\<lambda>n. (\<Sum>i\<in>Basis. g i n x)) \<longlonglongrightarrow> (if x \<in> UNIV then f x else 0)"
      by (simp add: euclidean_representation)
  qed
qed

corollary measurable_on_componentwise:
  "f measurable_on S \<longleftrightarrow> (\<forall>i\<in>Basis. (\<lambda>x. (f x \<bullet> i) *\<^sub>R i) measurable_on S)"
  apply (subst measurable_on_UNIV [symmetric])
  apply (subst measurable_on_componentwise_UNIV)
  apply (simp add: measurable_on_UNIV if_distrib [of "\<lambda>x. inner x _"] if_distrib [of "\<lambda>x. scaleR x _"] cong: if_cong)
  done


lemma\<^marker>\<open>tag important\<close> borel_measurable_implies_simple_function_sequence_real:
  fixes u :: "'a \<Rightarrow> real"
  assumes u[measurable]: "u \<in> borel_measurable M" and nn: "\<And>x. u x \<ge> 0"
  shows "\<exists>f. incseq f \<and> (\<forall>i. simple_function M (f i)) \<and> (\<forall>x. bdd_above (range (\<lambda>i. f i x))) \<and>
             (\<forall>i x. 0 \<le> f i x) \<and> u = (SUP i. f i)"
proof -
  define f where [abs_def]:
    "f i x = real_of_int (floor ((min i (u x)) * 2^i)) / 2^i" for i x

  have [simp]: "0 \<le> f i x" for i x
    by (auto simp: f_def intro!: divide_nonneg_nonneg mult_nonneg_nonneg nn)

  have *: "2^n * real_of_int x = real_of_int (2^n * x)" for n x
    by simp

  have "real_of_int \<lfloor>real i * 2 ^ i\<rfloor> = real_of_int \<lfloor>i * 2 ^ i\<rfloor>" for i
    by (intro arg_cong[where f=real_of_int]) simp
  then have [simp]: "real_of_int \<lfloor>real i * 2 ^ i\<rfloor> = i * 2 ^ i" for i
    unfolding floor_of_nat by simp

  have bdd: "bdd_above (range (\<lambda>i. f i x))" for x
    by (rule bdd_aboveI [where M = "u x"]) (auto simp: f_def field_simps min_def)

  have "incseq f"
  proof (intro monoI le_funI)
    fix m n :: nat and x assume "m \<le> n"
    moreover
    { fix d :: nat
      have "\<lfloor>2^d::real\<rfloor> * \<lfloor>2^m * (min (of_nat m) (u x))\<rfloor> \<le> \<lfloor>2^d * (2^m * (min (of_nat m) (u x)))\<rfloor>"
        by (rule le_mult_floor) (auto simp: nn)
      also have "\<dots> \<le> \<lfloor>2^d * (2^m *  (min (of_nat d + of_nat m) (u x)))\<rfloor>"
        by (intro floor_mono mult_mono min.mono)
           (auto simp: nn min_less_iff_disj of_nat_less_top)
      finally have "f m x \<le> f(m + d) x"
        unfolding f_def
        by (auto simp: field_simps power_add * simp del: of_int_mult) }
    ultimately show "f m x \<le> f n x"
      by (auto simp: le_iff_add)
  qed
  then have inc_f: "incseq (\<lambda>i. f i x)" for x
    by (auto simp: incseq_def le_fun_def)
  moreover
  have "simple_function M (f i)" for i
  proof (rule simple_function_borel_measurable)
    have "\<lfloor>(min (of_nat i) (u x)) * 2 ^ i\<rfloor> \<le> \<lfloor>int i * 2 ^ i\<rfloor>" for x
      by (auto split: split_min intro!: floor_mono)
    then have "f i ` space M \<subseteq> (\<lambda>n. real_of_int n / 2^i) ` {0 .. of_nat i * 2^i}"
      unfolding floor_of_int by (auto simp: f_def nn intro!: imageI)
    then show "finite (f i ` space M)"
      by (rule finite_subset) auto
    show "f i \<in> borel_measurable M"
      unfolding f_def enn2real_def by measurable
  qed
  moreover
  { fix x
    have "(SUP i. (f i x)) = u x"
    proof -
      obtain n where "u x \<le> of_nat n" using real_arch_simple by auto
      then have min_eq_r: "\<forall>\<^sub>F i in sequentially. min (real i) (u x) = u x"
        by (auto simp: eventually_sequentially intro!: exI[of _ n] split: split_min)
      have "(\<lambda>i. real_of_int \<lfloor>min (real i) (u x) * 2^i\<rfloor> / 2^i) \<longlonglongrightarrow> u x"
      proof (rule tendsto_sandwich)
        show "(\<lambda>n. u x - (1/2)^n) \<longlonglongrightarrow> u x"
          by (auto intro!: tendsto_eq_intros LIMSEQ_power_zero)
        show "\<forall>\<^sub>F n in sequentially. real_of_int \<lfloor>min (real n) (u x) * 2 ^ n\<rfloor> / 2 ^ n \<le> u x"
          using min_eq_r by eventually_elim (auto simp: field_simps)
        have *: "u x * (2 ^ n * 2 ^ n) \<le> 2^n + 2^n * real_of_int \<lfloor>u x * 2 ^ n\<rfloor>" for n
          using real_of_int_floor_ge_diff_one[of "u x * 2^n", THEN mult_left_mono, of "2^n"]
          by (auto simp: field_simps)
        show "\<forall>\<^sub>F n in sequentially. u x - (1/2)^n \<le> real_of_int \<lfloor>min (real n) (u x) * 2 ^ n\<rfloor> / 2 ^ n"
          using min_eq_r by eventually_elim (insert *, auto simp: field_simps)
      qed auto
      then have "(\<lambda>i. (f i x)) \<longlonglongrightarrow> u x"
        by (simp add: f_def)
      from LIMSEQ_unique LIMSEQ_incseq_SUP [OF bdd inc_f] this
      show ?thesis
        by blast
    qed }
  ultimately show ?thesis
    by (intro exI [of _ "\<lambda>i x. f i x"]) (auto simp: \<open>incseq f\<close> bdd image_comp)
qed


lemma homeomorphic_open_interval_UNIV:
  fixes a b:: real
  assumes "a < b"
  shows "{a<..<b} homeomorphic (UNIV::real set)"
proof -
  have "{a<..<b} = ball ((b+a) / 2) ((b-a) / 2)"
    using assms
    by (auto simp: dist_real_def abs_if divide_simps split: if_split_asm)
  then show ?thesis
    by (simp add: homeomorphic_ball_UNIV assms)
qed

proposition homeomorphic_box_UNIV:
  fixes a b:: "'a::euclidean_space"
  assumes "box a b \<noteq> {}"
  shows "box a b homeomorphic (UNIV::'a set)"
proof -
  have "{a \<bullet> i <..<b \<bullet> i} homeomorphic (UNIV::real set)" if "i \<in> Basis" for i
    using assms box_ne_empty that by (blast intro: homeomorphic_open_interval_UNIV)
  then have "\<exists>f g. (\<forall>x. a \<bullet> i < x \<and> x < b \<bullet> i \<longrightarrow> g (f x) = x) \<and>
                   (\<forall>y. a \<bullet> i < g y \<and> g y < b \<bullet> i \<and> f(g y) = y) \<and>
                   continuous_on {a \<bullet> i<..<b \<bullet> i} f \<and>
                   continuous_on (UNIV::real set) g"
    if "i \<in> Basis" for i
    using that by (auto simp: homeomorphic_minimal mem_box Ball_def)
  then obtain f g where gf: "\<And>i x. \<lbrakk>i \<in> Basis; a \<bullet> i < x; x < b \<bullet> i\<rbrakk> \<Longrightarrow> g i (f i x) = x"
              and fg: "\<And>i y. i \<in> Basis \<Longrightarrow> a \<bullet> i < g i y \<and> g i y < b \<bullet> i \<and> f i (g i y) = y"
              and contf: "\<And>i. i \<in> Basis \<Longrightarrow> continuous_on {a \<bullet> i<..<b \<bullet> i} (f i)"
              and contg: "\<And>i. i \<in> Basis \<Longrightarrow> continuous_on (UNIV::real set) (g i)"
    by metis
  define F where "F \<equiv> \<lambda>x. \<Sum>i\<in>Basis. (f i (x \<bullet> i)) *\<^sub>R i"
  define G where "G \<equiv> \<lambda>x. \<Sum>i\<in>Basis. (g i (x \<bullet> i)) *\<^sub>R i"
  show ?thesis
    unfolding homeomorphic_minimal
  proof (intro exI conjI ballI)
    show "G y \<in> box a b" for y
      using fg by (simp add: G_def mem_box)
    show "G (F x) = x" if "x \<in> box a b" for x
      using that by (simp add: F_def G_def gf mem_box euclidean_representation)
    show "F (G y) = y" for y
      by (simp add: F_def G_def fg mem_box euclidean_representation)
    show "continuous_on (box a b) F"
      unfolding F_def
    proof (intro continuous_intros continuous_on_compose2 [OF contf continuous_on_inner])
      show "(\<lambda>x. x \<bullet> i) ` box a b \<subseteq> {a \<bullet> i<..<b \<bullet> i}" if "i \<in> Basis" for i
        using that by (auto simp: mem_box)
    qed
    show "continuous_on UNIV G"
      unfolding G_def
      by (intro continuous_intros continuous_on_compose2 [OF contg continuous_on_inner]) auto
  qed auto
qed



lemma diff_null_sets_lebesgue: "\<lbrakk>N \<in> null_sets (lebesgue_on S); X-N \<in> sets (lebesgue_on S); N \<subseteq> X\<rbrakk>
    \<Longrightarrow> X \<in> sets (lebesgue_on S)"
  by (metis Int_Diff_Un inf.commute inf.orderE null_setsD2 sets.Un)

lemma borel_measurable_diff_null:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes N: "N \<in> null_sets (lebesgue_on S)" and S: "S \<in> sets lebesgue"
  shows "f \<in> borel_measurable (lebesgue_on (S-N)) \<longleftrightarrow> f \<in> borel_measurable (lebesgue_on S)"
  unfolding in_borel_measurable lebesgue_on_UNIV_eq space_lebesgue_on sets_restrict_UNIV
proof (intro ball_cong iffI)
  show "f -` T \<inter> S \<in> sets (lebesgue_on S)"
    if "f -` T \<inter> (S-N) \<in> sets (lebesgue_on (S-N))" for T
    using that  assms
    by (smt Diff_Int_distrib completion.complete2 diff_null_sets_lebesgue inf.idem inf_le2 inf_mono lebesgue_on_UNIV_eq null_setsD2 null_sets_restrict_space sets.Diff sets_restrict_space_iff space_lebesgue_on space_restrict_space)
  show "f -` T \<inter> (S-N) \<in> sets (lebesgue_on (S-N))"
    if "f -` T \<inter> S \<in> sets (lebesgue_on S)" for T
    using image_eqI inf.commute inf_top_right sets_restrict_space that
    by (smt Int_Diff S sets.Int_space_eq2 sets_restrict_space_iff space_lebesgue_on)
qed auto

lemma lebesgue_measurable_diff_null:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "N \<in> null_sets lebesgue"
  shows "f \<in> borel_measurable (lebesgue_on (-N)) \<longleftrightarrow> f \<in> borel_measurable lebesgue"
  by (simp add: Compl_eq_Diff_UNIV assms borel_measurable_diff_null lebesgue_on_UNIV_eq)



proposition measurable_on_imp_borel_measurable_lebesgue_UNIV:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "f measurable_on UNIV"
  shows "f \<in> borel_measurable lebesgue"
proof -
  obtain N and F
    where NF: "negligible N"
      and conF: "\<And>n. continuous_on UNIV (F n)"
      and tendsF: "\<And>x. x \<notin> N \<Longrightarrow> (\<lambda>n. F n x) \<longlonglongrightarrow> f x"
    using assms by (auto simp: measurable_on_def)
  obtain N where "N \<in> null_sets lebesgue" "f \<in> borel_measurable (lebesgue_on (-N))"
  proof
    show "f \<in> borel_measurable (lebesgue_on (- N))"
    proof (rule borel_measurable_LIMSEQ_metric)
      show "F i \<in> borel_measurable (lebesgue_on (- N))" for i
        by (meson Compl_in_sets_lebesgue NF conF continuous_imp_measurable_on_sets_lebesgue continuous_on_subset negligible_imp_sets subset_UNIV)
      show "(\<lambda>i. F i x) \<longlonglongrightarrow> f x" if "x \<in> space (lebesgue_on (- N))" for x
        using that
        by (simp add: tendsF)
    qed
    show "N \<in> null_sets lebesgue"
      using NF negligible_iff_null_sets by blast
  qed
  then show ?thesis
    using lebesgue_measurable_diff_null by blast
qed

corollary measurable_on_imp_borel_measurable_lebesgue:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "f measurable_on S" and S: "S \<in> sets lebesgue"
  shows "f \<in> borel_measurable (lebesgue_on S)"
proof -
  have "(\<lambda>x. if x \<in> S then f x else 0) measurable_on UNIV"
    using assms(1) measurable_on_UNIV by blast
  then show ?thesis
    by (simp add: borel_measurable_if_D measurable_on_imp_borel_measurable_lebesgue_UNIV)
qed


proposition measurable_on_limit:
  fixes f :: "nat \<Rightarrow> 'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes f: "\<And>n. f n measurable_on S" and N: "negligible N"
    and lim: "\<And>x. x \<in> S - N \<Longrightarrow> (\<lambda>n. f n x) \<longlonglongrightarrow> g x"
  shows "g measurable_on S"
proof -
  have "box (0::'b) One homeomorphic (UNIV::'b set)"
    by (simp add: homeomorphic_box_UNIV)
  then obtain h h':: "'b\<Rightarrow>'b" where hh': "\<And>x. x \<in> box 0 One \<Longrightarrow> h (h' x) = x"
                  and h'im:  "h' ` box 0 One = UNIV"
                  and conth: "continuous_on UNIV h"
                  and conth': "continuous_on (box 0 One) h'"
                  and h'h:   "\<And>y. h' (h y) = y"
                  and rangeh: "range h = box 0 One"
    by (auto simp: homeomorphic_def homeomorphism_def)
  have "norm y \<le> DIM('b)" if y: "y \<in> box 0 One" for y::'b
  proof -
    have y01: "0 < y \<bullet> i" "y \<bullet> i < 1" if "i \<in> Basis" for i
      using that y by (auto simp: mem_box)
    have "norm y \<le> (\<Sum>i\<in>Basis. \<bar>y \<bullet> i\<bar>)"
      using norm_le_l1 by blast
    also have "\<dots> \<le> (\<Sum>i::'b\<in>Basis. 1)"
    proof (rule sum_mono)
      show "\<bar>y \<bullet> i\<bar> \<le> 1" if "i \<in> Basis" for i
        using y01 that by fastforce
    qed
    also have "\<dots> \<le> DIM('b)"
      by auto
    finally show ?thesis .
  qed
  then have norm_le: "norm(h y) \<le> DIM('b)" for y
    by (metis UNIV_I image_eqI rangeh)
  have "(h' \<circ> (h \<circ> (\<lambda>x. if x \<in> S then g x else 0))) measurable_on UNIV"
  proof (rule measurable_on_compose_continuous_box)
    let ?\<chi> =  "h \<circ> (\<lambda>x. if x \<in> S then g x else 0)"
    let ?f = "\<lambda>n. h \<circ> (\<lambda>x. if x \<in> S then f n x else 0)"
    show "?\<chi> measurable_on UNIV"
    proof (rule integrable_subintervals_imp_measurable)
      show "?\<chi> integrable_on cbox a b" for a b
      proof (rule integrable_spike_set)
        show "?\<chi> integrable_on (cbox a b - N)"
        proof (rule dominated_convergence_integrable)
          show const: "(\<lambda>x. DIM('b)) integrable_on cbox a b - N"
            by (simp add: N has_integral_iff integrable_const integrable_negligible integrable_setdiff negligible_diff)
          show "norm ((h \<circ> (\<lambda>x. if x \<in> S then g x else 0)) x) \<le> DIM('b)" if "x \<in> cbox a b - N" for x
            using that norm_le  by (simp add: o_def)
          show "(\<lambda>k. ?f k x) \<longlonglongrightarrow> ?\<chi> x" if "x \<in> cbox a b - N" for x
            using that lim [of x] conth
            by (auto simp: continuous_on_def intro: tendsto_compose)
          show "(?f n) absolutely_integrable_on cbox a b - N" for n
          proof (rule measurable_bounded_by_integrable_imp_absolutely_integrable)
            show "?f n \<in> borel_measurable (lebesgue_on (cbox a b - N))"
            proof (rule measurable_on_imp_borel_measurable_lebesgue [OF measurable_on_spike_set])
              show "?f n measurable_on cbox a b"
                unfolding measurable_on_UNIV [symmetric, of _ "cbox a b"]
              proof (rule measurable_on_restrict)
                have f': "(\<lambda>x. if x \<in> S then f n x else 0) measurable_on UNIV"
                  by (simp add: f measurable_on_UNIV)
                show "?f n measurable_on UNIV"
                  using measurable_on_compose_continuous [OF f' conth] by auto
              qed auto
              show "negligible (cbox a b \<Delta> (cbox a b - N))"
                by (auto intro: negligible_subset [OF N])
              show "cbox a b - N \<in> sets lebesgue"
                by (simp add: N negligible_imp_sets sets.Diff)
            qed
            show "cbox a b - N \<in> sets lebesgue"
              by (simp add: N negligible_imp_sets sets.Diff)
            show "norm (?f n x) \<le> DIM('b)"
              if "x \<in> cbox a b - N" for x
              using that local.norm_le by simp
          qed (auto simp: const)
        qed
        show "negligible {x \<in> cbox a b - N - cbox a b. ?\<chi> x \<noteq> 0}"
          by (auto simp: empty_imp_negligible)
        have "{x \<in> cbox a b - (cbox a b - N). ?\<chi> x \<noteq> 0} \<subseteq> N"
          by auto
        then show "negligible {x \<in> cbox a b - (cbox a b - N). ?\<chi> x \<noteq> 0}"
          using N negligible_subset by blast
      qed
    qed
    show "?\<chi> x \<in> box 0 One" for x
      using rangeh by auto
    show "continuous_on (box 0 One) h'"
      by (rule conth')
  qed
  then show ?thesis
    by (simp add: o_def h'h measurable_on_UNIV)
qed


lemma measurable_on_if_simple_function_limit:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  shows  "\<lbrakk>\<And>n. g n measurable_on UNIV; \<And>n. finite (range (g n)); \<And>x. (\<lambda>n. g n x) \<longlonglongrightarrow> f x\<rbrakk>
   \<Longrightarrow> f measurable_on UNIV"
  by (force intro: measurable_on_limit [where N="{}"])


lemma lebesgue_measurable_imp_measurable_on_nnreal_UNIV:
  fixes u :: "'a::euclidean_space \<Rightarrow> real"
  assumes u: "u \<in> borel_measurable lebesgue" and nn: "\<And>x. u x \<ge> 0"
  shows "u measurable_on UNIV"
proof -
  obtain f where "incseq f" and f: "\<forall>i. simple_function lebesgue (f i)"
    and bdd: "\<And>x. bdd_above (range (\<lambda>i. f i x))"
    and nnf: "\<And>i x. 0 \<le> f i x" and *: "u = (SUP i. f i)"
    using borel_measurable_implies_simple_function_sequence_real nn u by metis
  show ?thesis
    unfolding *
  proof (rule measurable_on_if_simple_function_limit [of concl: "\<Squnion> range f"])
    show "(f i) measurable_on UNIV" for i
      by (simp add: f nnf simple_function_measurable_on_UNIV)
    show "finite (range (f i))" for i
      by (metis f simple_function_def space_borel space_completion space_lborel)
    show "(\<lambda>i. f i x) \<longlonglongrightarrow> (\<Squnion> range f) x" for x
    proof -
      have "incseq (\<lambda>i. f i x)"
        using \<open>incseq f\<close> apply (auto simp: incseq_def)
        by (simp add: le_funD)
      then show ?thesis
        by (metis SUP_apply bdd LIMSEQ_incseq_SUP)
    qed
  qed
qed

lemma lebesgue_measurable_imp_measurable_on_nnreal:
  fixes u :: "'a::euclidean_space \<Rightarrow> real"
  assumes "u \<in> borel_measurable lebesgue" "\<And>x. u x \<ge> 0""S \<in> sets lebesgue"
  shows "u measurable_on S"
  unfolding measurable_on_UNIV [symmetric, of u]
  using assms
  by (auto intro: lebesgue_measurable_imp_measurable_on_nnreal_UNIV)

lemma lebesgue_measurable_imp_measurable_on_real:
  fixes u :: "'a::euclidean_space \<Rightarrow> real"
  assumes u: "u \<in> borel_measurable lebesgue" and S: "S \<in> sets lebesgue"
  shows "u measurable_on S"
proof -
  let ?f = "\<lambda>x. \<bar>u x\<bar> + u x"
  let ?g = "\<lambda>x. \<bar>u x\<bar> - u x"
  have "?f measurable_on S" "?g measurable_on S"
    using S u by (auto intro: lebesgue_measurable_imp_measurable_on_nnreal)
  then have "(\<lambda>x. (?f x - ?g x) / 2) measurable_on S"
    using measurable_on_cdivide measurable_on_diff by blast
  then show ?thesis
    by auto
qed


proposition lebesgue_measurable_imp_measurable_on:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes f: "f \<in> borel_measurable lebesgue" and S: "S \<in> sets lebesgue"
  shows "f measurable_on S"
  unfolding measurable_on_componentwise [of f]
proof
  fix i::'b
  assume "i \<in> Basis"
  have "(\<lambda>x. (f x \<bullet> i)) \<in> borel_measurable lebesgue"
    using \<open>i \<in> Basis\<close> borel_measurable_euclidean_space f by blast
  then have "(\<lambda>x. (f x \<bullet> i)) measurable_on S"
    using S lebesgue_measurable_imp_measurable_on_real by blast
  then show "(\<lambda>x. (f x \<bullet> i) *\<^sub>R i) measurable_on S"
    by (intro measurable_on_scaleR measurable_on_const S)
qed

proposition measurable_on_iff_borel_measurable:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "S \<in> sets lebesgue"
  shows "f measurable_on S \<longleftrightarrow> f \<in> borel_measurable (lebesgue_on S)" (is "?lhs = ?rhs")
proof
  show "f \<in> borel_measurable (lebesgue_on S)"
    if "f measurable_on S"
    using that by (simp add: assms measurable_on_imp_borel_measurable_lebesgue)
next
  assume "f \<in> borel_measurable (lebesgue_on S)"
  then have "(\<lambda>a. if a \<in> S then f a else 0) measurable_on UNIV"
    by (simp add: assms borel_measurable_if_I lebesgue_measurable_imp_measurable_on)
  then show "f measurable_on S"
    using measurable_on_UNIV by blast
qed

lemma measurable_on_bilinear:
  fixes h :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space \<Rightarrow> 'c::euclidean_space"
  assumes h: "bilinear h" and f: "f measurable_on S" and g: "g measurable_on S"
  shows "(\<lambda>x. h (f x) (g x)) measurable_on S"
proof (rule measurable_on_combine [where h = h])
  show "continuous_on UNIV (\<lambda>x. h (fst x) (snd x))"
    by (metis (mono_tags, lifting) bilinear_continuous_on_compose continuous_on_cong continuous_on_fst continuous_on_id continuous_on_snd h)
  show "h 0 0 = 0"
  by (simp add: bilinear_lzero h)
qed (auto intro: assms)

lemma borel_measurable_bilinear:
  fixes h :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space \<Rightarrow> 'c::euclidean_space"
  assumes "bilinear h" "f \<in> borel_measurable (lebesgue_on S)" "g \<in> borel_measurable (lebesgue_on S)"
    and S: "S \<in> sets lebesgue"
  shows "(\<lambda>x. h (f x) (g x)) \<in> borel_measurable (lebesgue_on S)"
  using assms measurable_on_bilinear [of h f S g]
  by (simp flip: measurable_on_iff_borel_measurable)


lemma absolutely_integrable_bounded_measurable_product:
  fixes h :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space \<Rightarrow> 'c::euclidean_space"
  assumes "bilinear h" and f: "f \<in> borel_measurable (lebesgue_on S)" "S \<in> sets lebesgue"
    and bou: "bounded (f ` S)" and g: "g absolutely_integrable_on S"
  shows "(\<lambda>x. h (f x) (g x)) absolutely_integrable_on S"
proof -
  obtain B where "B > 0" and B: "\<And>x y. norm (h x y) \<le> B * norm x * norm y"
    using bilinear_bounded_pos \<open>bilinear h\<close> by blast
  obtain C where "C > 0" and C: "\<And>x. x \<in> S \<Longrightarrow> norm (f x) \<le> C"
    using bounded_pos by (metis bou imageI)
  show ?thesis
  proof (rule measurable_bounded_by_integrable_imp_absolutely_integrable [OF _ \<open>S \<in> sets lebesgue\<close>])
    show "norm (h (f x) (g x)) \<le> B * C * norm(g x)" if "x \<in> S" for x
      by (meson less_le mult_left_mono mult_right_mono norm_ge_zero order_trans that \<open>B > 0\<close> B C)
    show "(\<lambda>x. h (f x) (g x)) \<in> borel_measurable (lebesgue_on S)"
      using \<open>bilinear h\<close> f g absolutely_integrable_measurable borel_measurable_bilinear by blast
    show "(\<lambda>x. B * C * norm(g x)) integrable_on S"
      using \<open>0 < B\<close> \<open>0 < C\<close> absolutely_integrable_on_def g by auto
  qed
qed

lemma absolutely_integrable_bounded_measurable_product_real:
  fixes f :: "real \<Rightarrow> real"
  assumes "f \<in> borel_measurable (lebesgue_on S)" "S \<in> sets lebesgue"
      and "bounded (f ` S)" and "g absolutely_integrable_on S"
  shows "(\<lambda>x. f x * g x) absolutely_integrable_on S"
  using absolutely_integrable_bounded_measurable_product bilinear_times assms by blast




lemma set_integrable_mult_right_iff [simp]:
  fixes a :: "'a::{real_normed_field, second_countable_topology}"
  assumes "a \<noteq> 0"
  shows "set_integrable M A (\<lambda>t. a * f t) \<longleftrightarrow> set_integrable M A f"
proof
  assume "set_integrable M A (\<lambda>t. a * f t)"
  then have "set_integrable M A (\<lambda>t. 1/a * (a * f t))"
    using set_integrable_mult_right by blast
  then show "set_integrable M A f"
    using assms by auto
qed auto

lemma set_integrable_mult_left_iff [simp]:
  fixes a :: "'a::{real_normed_field, second_countable_topology}"
  assumes "a \<noteq> 0"
  shows "set_integrable M A (\<lambda>t. f t * a) \<longleftrightarrow> set_integrable M A f"
  using assms
  by (subst set_integrable_mult_right_iff [symmetric]) (auto simp: mult.commute)


lemma set_integrable_mult_divide_iff [simp]:
  fixes a :: "'a::{real_normed_field, second_countable_topology}"
  assumes "a \<noteq> 0"
  shows "set_integrable M A (\<lambda>t. f t / a) \<longleftrightarrow> set_integrable M A f"
  by (simp add: divide_inverse assms)


lemma borel_measurable_AE:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "f \<in> borel_measurable lebesgue" and ae: "AE x in lebesgue. f x = g x"
  shows "g \<in> borel_measurable lebesgue"
proof -
  obtain N where N: "N \<in> null_sets lebesgue" "\<And>x. x \<notin> N \<Longrightarrow> f x = g x"
    using AE_null_sets_lebesgue [OF ae] by blast
  have "f measurable_on UNIV"
    by (simp add: assms lebesgue_measurable_imp_measurable_on)
  then have "g measurable_on UNIV"
    by (metis Diff_iff N measurable_on_spike negligible_iff_null_sets)
  then show ?thesis
    using measurable_on_imp_borel_measurable_lebesgue_UNIV by blast
qed


lemma has_bochner_integral_combine:
  fixes f :: "real \<Rightarrow> 'a::euclidean_space"
  assumes "a \<le> c" "c \<le> b"
    and ac: "has_bochner_integral (lebesgue_on {a..c}) f i"
    and cb: "has_bochner_integral (lebesgue_on {c..b}) f j"
  shows "has_bochner_integral (lebesgue_on {a..b}) f(i + j)"
proof -
  have i: "has_bochner_integral lebesgue (\<lambda>x. indicator {a..c} x *\<^sub>R f x) i"
   and j: "has_bochner_integral lebesgue (\<lambda>x. indicator {c..b} x *\<^sub>R f x) j"
    using assms  by (auto simp: has_bochner_integral_restrict_space)
  have AE: "AE x in lebesgue. indicat_real {a..c} x *\<^sub>R f x + indicat_real {c..b} x *\<^sub>R f x = indicat_real {a..b} x *\<^sub>R f x"
  proof (rule AE_I')
    have eq: "indicat_real {a..c} x *\<^sub>R f x + indicat_real {c..b} x *\<^sub>R f x = indicat_real {a..b} x *\<^sub>R f x" if "x \<noteq> c" for x
      using assms that by (auto simp: indicator_def)
    then show "{x \<in> space lebesgue. indicat_real {a..c} x *\<^sub>R f x + indicat_real {c..b} x *\<^sub>R f x \<noteq> indicat_real {a..b} x *\<^sub>R f x} \<subseteq> {c}"
      by auto
  qed auto
  have "has_bochner_integral lebesgue (\<lambda>x. indicator {a..b} x *\<^sub>R f x) (i + j)"
  proof (rule has_bochner_integralI_AE [OF has_bochner_integral_add [OF i j] _ AE])
    have eq: "indicat_real {a..c} x *\<^sub>R f x + indicat_real {c..b} x *\<^sub>R f x = indicat_real {a..b} x *\<^sub>R f x" if "x \<noteq> c" for x
      using assms that by (auto simp: indicator_def)
    show "(\<lambda>x. indicat_real {a..b} x *\<^sub>R f x) \<in> borel_measurable lebesgue"
    proof (rule borel_measurable_AE [OF borel_measurable_add AE])
      show "(\<lambda>x. indicator {a..c} x *\<^sub>R f x) \<in> borel_measurable lebesgue"
           "(\<lambda>x. indicator {c..b} x *\<^sub>R f x) \<in> borel_measurable lebesgue"
        using i j by auto
    qed
  qed
  then show ?thesis
    by (simp add: has_bochner_integral_restrict_space)
qed

lemma integrable_combine:
  fixes f :: "real \<Rightarrow> 'a::euclidean_space"
  assumes "integrable (lebesgue_on {a..c}) f" "integrable (lebesgue_on {c..b}) f"
    and "a \<le> c" "c \<le> b"
  shows "integrable (lebesgue_on {a..b}) f"
  using assms has_bochner_integral_combine has_bochner_integral_iff by blast

lemma integral_combine:
  fixes f :: "real \<Rightarrow> 'a::euclidean_space"
  assumes f: "integrable (lebesgue_on {a..b}) f" and "a \<le> c" "c \<le> b"
  shows "integral\<^sup>L (lebesgue_on {a..b}) f = integral\<^sup>L (lebesgue_on {a..c}) f + integral\<^sup>L (lebesgue_on {c..b}) f"
proof -
  have i: "has_bochner_integral (lebesgue_on {a..c}) f(integral\<^sup>L (lebesgue_on {a..c}) f)"
    using integrable_subinterval_real \<open>c \<le> b\<close> f has_bochner_integral_iff by fastforce
  have j: "has_bochner_integral (lebesgue_on {c..b}) f(integral\<^sup>L (lebesgue_on {c..b}) f)"
    using integrable_subinterval_real \<open>a \<le> c\<close> f has_bochner_integral_iff by fastforce
  show ?thesis
    by (meson \<open>a \<le> c\<close> \<open>c \<le> b\<close> has_bochner_integral_combine has_bochner_integral_iff i j)
qed

lemma has_bochner_integral_reflect_real_lemma[intro]:
  fixes f :: "real \<Rightarrow> 'a::euclidean_space"
  assumes "has_bochner_integral (lebesgue_on {a..b}) f i"
  shows "has_bochner_integral (lebesgue_on {-b..-a}) (\<lambda>x. f(-x)) i"
proof -
  have eq: "indicat_real {a..b} (- x) *\<^sub>R f(- x) = indicat_real {- b..- a} x *\<^sub>R f(- x)" for x
    by (auto simp: indicator_def)
  have i: "has_bochner_integral lebesgue (\<lambda>x. indicator {a..b} x *\<^sub>R f x) i"
    using assms by (auto simp: has_bochner_integral_restrict_space)
  then have "has_bochner_integral lebesgue (\<lambda>x. indicator {-b..-a} x *\<^sub>R f(-x)) i"
    using has_bochner_integral_lebesgue_real_affine_iff [of "-1" "(\<lambda>x. indicator {a..b} x *\<^sub>R f x)" i 0]
    by (auto simp: eq)
  then show ?thesis
    using assms by blast
qed

lemma has_bochner_integral_reflect_real[simp]:
  fixes f :: "real \<Rightarrow> 'a::euclidean_space"
  shows "has_bochner_integral (lebesgue_on {-b..-a}) (\<lambda>x. f(-x)) i \<longleftrightarrow> has_bochner_integral (lebesgue_on {a..b}) f i"
  by (auto simp: dest: has_bochner_integral_reflect_real_lemma)

lemma has_bochner_integral_null [intro]:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "N \<in> null_sets lebesgue"
  shows "has_bochner_integral (lebesgue_on N) f 0"
  unfolding has_bochner_integral_iff
proof
  show "integrable (lebesgue_on N) f"
  proof (subst integrable_restrict_space)
    show "N \<inter> space lebesgue \<in> sets lebesgue"
      using assms by force
    show "integrable lebesgue (\<lambda>x. indicat_real N x *\<^sub>R f x)"
    proof (rule integrable_cong_AE_imp)
      show "integrable lebesgue (\<lambda>x. 0)"
        by simp
      show *: "AE x in lebesgue. 0 = indicat_real N x *\<^sub>R f x"
        using assms
        by (simp add: indicator_def completion.null_sets_iff_AE eventually_mono)
      show "(\<lambda>x. indicat_real N x *\<^sub>R f x) \<in> borel_measurable lebesgue"
        by (auto intro: borel_measurable_AE [OF _ *])
    qed
  qed
  show "integral\<^sup>L (lebesgue_on N) f = 0"
  proof (rule integral_eq_zero_AE)
    show "AE x in lebesgue_on N. f x = 0"
      by (rule AE_I' [where N=N]) (auto simp: assms null_setsD2 null_sets_restrict_space)
  qed
qed


lemma has_bochner_integral_null_eq[simp]:
  fixes f :: "'a::euclidean_space \<Rightarrow> 'b::euclidean_space"
  assumes "N \<in> null_sets lebesgue"
  shows "has_bochner_integral (lebesgue_on N) f i \<longleftrightarrow> i = 0"
  using assms has_bochner_integral_eq by blast

lemma integrable_reflect_real[simp]:
  fixes f :: "real \<Rightarrow> 'a::euclidean_space"
  shows "integrable (lebesgue_on {-b..-a}) (\<lambda>x. f(-x)) \<longleftrightarrow> integrable (lebesgue_on {a..b}) f"
  by (metis has_bochner_integral_iff has_bochner_integral_reflect_real)

lemma integral_reflect_real[simp]:
  fixes f :: "real \<Rightarrow> 'a::euclidean_space"
  shows "integral\<^sup>L (lebesgue_on {-b .. -a}) (\<lambda>x. f(-x)) = integral\<^sup>L (lebesgue_on {a..b::real}) f"
  using has_bochner_integral_reflect_real [of b a f]
  by (metis has_bochner_integral_iff not_integrable_integral_eq)

lemma monoseq_convergent:
  fixes X :: "nat \<Rightarrow> real"
  assumes X: "monoseq X" and B: "\<And>i. \<bar>X i\<bar> \<le> B"
  obtains L where "X \<longlonglongrightarrow> L"
  using X unfolding monoseq_iff
proof
  assume "incseq X"
  show thesis
    using abs_le_D1 [OF B] incseq_convergent [OF \<open>incseq X\<close>] that by meson
next
  assume "decseq X"
  show thesis
    using decseq_convergent [OF \<open>decseq X\<close>] that
    by (metis B abs_le_iff add.inverse_inverse neg_le_iff_le)
qed

end
