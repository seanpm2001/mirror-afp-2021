(* Title:      Matrices over Extended Reals
   Author:     Walter Guttmann
   Maintainer: Walter Guttmann <walter.guttmann at canterbury.ac.nz>
*)

section {* Matrices over Extended Reals *}

text {*
In this theory we characterise relation-algebraic properties of matrices over extended reals in terms of the entries in the matrices.
We consider, in particular, the following properties: univalent, injective, total, surjective, mapping, bijective, vector, covector, point, atom, reflexive, coreflexive, irreflexive, symmetric, antisymmetric, asymmetric.
We also consider the effect of composition with the matrix of greatest elements and with coreflexives (tests).
*}

theory Extended_Real_Matrices

imports Matrix_Relation_Algebras Extended_Reals

begin

type_synonym 'a ext_real_square = "('a,ext_real) square"

text {*
We first generalise selectivity to finite suprema.
*}

lemma ext_real_finite_sup_selective:
  fixes f :: "'a::finite \<Rightarrow> ext_real"
  shows "\<exists>i . (\<Squnion>\<^sub>k f k) = f i"
  apply (induct rule: one_sup_induct)
  apply blast
  using ext_real_sup_selective by fastforce

lemma ext_real_top_finite_sup:
  fixes f :: "'a::finite \<Rightarrow> ext_real"
  assumes "\<forall>k . f k \<noteq> top"
    shows "(\<Squnion>\<^sub>k f k) \<noteq> top"
  by (metis assms ext_real_finite_sup_selective)

text {*
The following results show the effect of composition with the @{text top} matrix from the left and from the right.
*}

lemma comp_top_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "(f \<odot> mtop) (i,j) = (\<Squnion>\<^sub>k f (i,k))"
  apply (unfold times_matrix_def top_matrix_def)
  using one_ext_real_def by auto

lemma top_comp_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "(mtop \<odot> f) (i,j) = (\<Squnion>\<^sub>k f (k,j))"
  apply (unfold times_matrix_def top_matrix_def)
  using one_ext_real_def by auto

text {*
We characterise univalent matrices: in each row, at most one entry may be different from @{text bot}.
*}

lemma univalent_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_stone_relation_algebra.univalent f"
      and "f (i,j) \<noteq> bot"
      and "f (i,k) \<noteq> bot"
    shows "j = k"
proof -
  have "(f\<^sup>t \<odot> f) (j,k) = (\<Squnion>\<^sub>l (f\<^sup>t) (j,l) * f (l,k))"
    by (simp add: times_matrix_def)
  also have "... = (\<Squnion>\<^sub>l (f (l,j))\<^sup>T * f (l,k))"
    by (simp add: conv_matrix_def)
  also have "... = (\<Squnion>\<^sub>l f (l,j) * f (l,k))"
    by (simp add: conv_ext_real_def)
  also have "... \<ge> f (i,j) * f (i,k)"
    using comp_inf.ub_sum by fastforce
  finally have "(f\<^sup>t \<odot> f) (j,k) \<noteq> bot"
    using assms(2) assms(3) bot.extremum_uniqueI ext_real_bot_product by fastforce
  hence "mone (j,k) \<noteq> (bot::ext_real)"
    by (metis assms(1) bot.extremum_uniqueI less_eq_matrix_def)
  thus ?thesis
    by (metis (mono_tags, lifting) case_prod_conv one_matrix_def)
qed

lemma univalent_ext_real_matrix_2:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<forall>i j k . f (i,j) \<noteq> bot \<and> f (i,k) \<noteq> bot \<longrightarrow> j = k"
    shows "matrix_stone_relation_algebra.univalent f"
proof -
  show "f\<^sup>t \<odot> f \<preceq> mone"
  proof (unfold less_eq_matrix_def, rule allI, rule prod_cases)
    fix j k
    show "(f\<^sup>t \<odot> f) (j,k) \<le> mone (j,k)"
    proof (cases "j = k")
      assume "j = k"
      thus ?thesis
        by (simp add: one_matrix_def one_ext_real_def)
    next
      assume "j \<noteq> k"
      hence "(\<Squnion>\<^sub>i f (i,j) * f (i,k)) = bot"
        by (metis (no_types, lifting) assms semiring.mult_not_zero sup_monoid.sum.neutral)
      thus ?thesis
        by (simp add: times_matrix_def conv_matrix_def conv_ext_real_def)
    qed
  qed
qed

lemma univalent_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.univalent f \<longleftrightarrow> (\<forall>i j k . f (i,j) \<noteq> bot \<and> f (i,k) \<noteq> bot \<longrightarrow> j = k)"
  using univalent_ext_real_matrix_1 univalent_ext_real_matrix_2 by auto

text {*
Injective matrices can then be characterised by applying converse: in each column, at most one entry may be different from @{text bot}.
*}

lemma injective_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.injective f \<longleftrightarrow> (\<forall>i j k . f (j,i) \<noteq> bot \<and> f (k,i) \<noteq> bot \<longrightarrow> j = k)"
  by (unfold matrix_stone_relation_algebra.injective_conv_univalent univalent_ext_real_matrix) (simp add: conv_matrix_def conv_ext_real_def)

text {*
Next come total matrices: each row has a @{text top} entry.
*}

lemma total_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_stone_relation_algebra.total_var f"
    shows "\<exists>j . f (i,j) = top"
proof -
  have "mone (i,i) \<le> (f \<odot> f\<^sup>t) (i,i)"
    using assms less_eq_matrix_def by blast
  hence "top = (f \<odot> f\<^sup>t) (i,i)"
    by (simp add: one_matrix_def one_ext_real_def top.extremum_unique)
  also have "... = (\<Squnion>\<^sub>j f (i,j) * (f\<^sup>t) (j,i))"
    by (simp add: times_matrix_def)
  also have "... = (\<Squnion>\<^sub>j f (i,j) * f (i,j))"
    by (simp add: conv_matrix_def conv_ext_real_def)
  also have "... = (\<Squnion>\<^sub>j f (i,j))"
    by (simp add: times_ext_real_def)
  finally show ?thesis
    by (metis ext_real_top_finite_sup)
qed

lemma total_ext_real_matrix_2:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<forall>i . \<exists>j . f (i,j) = top"
    shows "matrix_stone_relation_algebra.total_var f"
proof (unfold less_eq_matrix_def, rule allI, rule prod_cases)
  fix j k
  show "mone (j,k) \<le> (f \<odot> f\<^sup>t) (j,k)"
  proof (cases "j = k")
    assume "j = k"
    hence "(\<Squnion>\<^sub>i f (j,i) * (f\<^sup>t) (i,k)) = (\<Squnion>\<^sub>i f (j,i))"
      by (simp add: conv_ext_real_def conv_matrix_def times_ext_real_def)
    also have "... = top"
      by (metis (no_types) assms comp_inf.ub_sum sup.absorb2 sup_top_left)
    finally show ?thesis
      by (simp add: times_matrix_def)
  next
    assume "j \<noteq> k"
    thus ?thesis
      by (simp add: one_matrix_def one_ext_real_def)
  qed
qed

lemma total_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_bounded_idempotent_semiring.total f \<longleftrightarrow> (\<forall>i . \<exists>j . f (i,j) = top)"
  using total_ext_real_matrix_1 total_ext_real_matrix_2 matrix_stone_relation_algebra.total_var by auto

text {*
Surjective matrices are again characterised by applying converse: each column has a @{text top} entry.
*}

lemma surjective_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_bounded_idempotent_semiring.surjective f \<longleftrightarrow> (\<forall>j . \<exists>i . f (i,j) = top)"
  by (unfold matrix_stone_relation_algebra.surjective_conv_total total_ext_real_matrix) (simp add: conv_matrix_def conv_ext_real_def)

text {*
A mapping therefore means that each row has exactly one @{text top} entry and all others are @{text bot}.
*}

lemma mapping_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.mapping f \<longleftrightarrow> (\<forall>i . \<exists>j . f (i,j) = top \<and> (\<forall>k . j \<noteq> k \<longrightarrow> f (i,k) = bot))"
  by (metis univalent_ext_real_matrix total_ext_real_matrix bot_ext_real_def ext_real.simps(5) top_ext_real_def)

lemma mapping_ext_real_matrix_unique:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.mapping f \<longleftrightarrow> (\<forall>i . \<exists>!j . f (i,j) = top \<and> (\<forall>k . j \<noteq> k \<longrightarrow> f (i,k) = bot))"
  apply (rule iffI)
  apply (metis univalent_ext_real_matrix total_ext_real_matrix bot_ext_real_def ext_real.simps(5) top_ext_real_def)
  by (metis univalent_ext_real_matrix total_ext_real_matrix)

text {*
Conversely, bijective means that each column has exactly one @{text top} entry and all others are @{text bot}.
*}

lemma bijective_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.bijective f \<longleftrightarrow> (\<forall>j . \<exists>i . f (i,j) = top \<and> (\<forall>k . i \<noteq> k \<longrightarrow> f (k,j) = bot))"
  by (unfold matrix_stone_relation_algebra.bijective_conv_mapping mapping_ext_real_matrix) (simp add: conv_matrix_def conv_ext_real_def)

lemma bijective_ext_real_matrix_unique:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.bijective f \<longleftrightarrow> (\<forall>j . \<exists>!i . f (i,j) = top \<and> (\<forall>k . i \<noteq> k \<longrightarrow> f (k,j) = bot))"
  by (unfold matrix_stone_relation_algebra.bijective_conv_mapping mapping_ext_real_matrix_unique) (simp add: conv_matrix_def conv_ext_real_def)

text {*
We derive algebraic characterisations of matrices in which each row has an entry that is different from @{text bot}.
*}

lemma pp_total_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<ominus>(f \<odot> mtop) = mbot"
    shows "\<exists>j . f (i,j) \<noteq> bot"
proof -
  have "\<not>(\<exists>j . f (i,j) \<noteq> bot) \<Longrightarrow> \<ominus>(f \<odot> mtop) \<noteq> mbot"
  proof -
    assume "\<not>(\<exists>j . f (i,j) \<noteq> bot)"
    hence "top = -(f \<odot> mtop) (i,i)"
      by (simp add: comp_top_ext_real_matrix ext_real_finite_sup_selective)
    also have "... = (\<ominus>(f \<odot> mtop)) (i,i)"
      by (simp add: uminus_matrix_def)
    finally show "\<ominus>(f \<odot> mtop) \<noteq> mbot"
      by (metis bot_ext_real_def bot_matrix_def ext_real.simps(4) top_ext_real_def)
  qed
  thus ?thesis
    using assms by blast
qed

lemma pp_total_ext_real_matrix_2:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<forall>i . \<exists>j . f (i,j) \<noteq> bot"
    shows "\<ominus>(f \<odot> mtop) = mbot"
proof (rule ext, rule prod_cases)
  fix i j
  have "(\<ominus>(f \<odot> mtop)) (i,j) = -(\<Squnion>\<^sub>k f (i,k))"
    by (simp add: comp_top_ext_real_matrix uminus_matrix_def)
  also have "... = bot"
    by (metis assms bot_ext_real_def comp_inf.ub_sum sup.absorb1 sup_monoid.add_0_left uminus_ext_real.elims)
  finally show "(\<ominus>(f \<odot> mtop)) (i,j) = mbot (i,j)"
    by (simp add: bot_matrix_def)
qed

lemma pp_total_ext_real_matrix_3:
  fixes f :: "'a::finite ext_real_square"
  shows "\<ominus>(f \<odot> mtop) = mbot \<longleftrightarrow> (\<forall>i . \<exists>j . f (i,j) \<noteq> bot)"
  using pp_total_ext_real_matrix_1 pp_total_ext_real_matrix_2 by auto

lemma pp_total_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_bounded_idempotent_semiring.total (\<ominus>\<ominus>f) \<longleftrightarrow> (\<forall>i . \<exists>j . f (i,j) \<noteq> bot)"
  using matrix_stone_relation_algebra.pp_total pp_total_ext_real_matrix_1 pp_total_ext_real_matrix_2 by auto

lemma pp_mapping_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.pp_mapping f \<longleftrightarrow> (\<forall>i . \<exists>j . f (i,j) \<noteq> bot \<and> (\<forall>k . j \<noteq> k \<longrightarrow> f (i,k) = bot))"
  by (metis univalent_ext_real_matrix pp_total_ext_real_matrix bot_ext_real_def)

lemma pp_mapping_ext_real_matrix_unique:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.pp_mapping f \<longleftrightarrow> (\<forall>i . \<exists>!j . f (i,j) \<noteq> bot \<and> (\<forall>k . j \<noteq> k \<longrightarrow> f (i,k) = bot))"
  apply (rule iffI)
  apply (metis univalent_ext_real_matrix pp_total_ext_real_matrix bot_ext_real_def)
  by (metis univalent_ext_real_matrix pp_total_ext_real_matrix)

text {*
Next follow matrices in which each column has an entry that is different from @{text bot}.
*}

lemma pp_surjective_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  shows "\<ominus>(mtop \<odot> f) = mbot \<longleftrightarrow> (\<forall>j . \<exists>i . f (i,j) \<noteq> bot)"
proof -
  have "\<ominus>(mtop \<odot> f) = mbot \<longleftrightarrow> (\<ominus>(mtop \<odot> f))\<^sup>t = mbot\<^sup>t"
    by (metis matrix_stone_relation_algebra.conv_involutive)
  also have "... \<longleftrightarrow> \<ominus>(f\<^sup>t \<odot> mtop) = mbot"
    by (simp add: matrix_stone_relation_algebra.conv_complement matrix_stone_relation_algebra.conv_dist_comp)
  also have "... \<longleftrightarrow> (\<forall>i . \<exists>j . (f\<^sup>t) (i,j) \<noteq> bot)"
    using pp_total_ext_real_matrix_3 by auto
  also have "... \<longleftrightarrow> (\<forall>j . \<exists>i . f (i,j) \<noteq> bot)"
    by (simp add: conv_matrix_def conv_ext_real_def)
  finally show ?thesis
    .
qed

lemma pp_surjective_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_bounded_idempotent_semiring.surjective (\<ominus>\<ominus>f) \<longleftrightarrow> (\<forall>j . \<exists>i . f (i,j) \<noteq> bot)"
  using matrix_stone_relation_algebra.pp_surjective pp_surjective_ext_real_matrix_1 by auto

lemma pp_bijective_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.pp_bijective f \<longleftrightarrow> (\<forall>j . \<exists>i . f (i,j) \<noteq> bot \<and> (\<forall>k . i \<noteq> k \<longrightarrow> f (k,j) = bot))"
  by (unfold matrix_stone_relation_algebra.pp_bijective_conv_mapping pp_mapping_ext_real_matrix) (simp add: conv_matrix_def conv_ext_real_def)

lemma pp_bijective_ext_real_matrix_unique:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.pp_bijective f \<longleftrightarrow> (\<forall>j . \<exists>!i . f (i,j) \<noteq> bot \<and> (\<forall>k . i \<noteq> k \<longrightarrow> f (k,j) = bot))"
  by (unfold matrix_stone_relation_algebra.pp_bijective_conv_mapping pp_mapping_ext_real_matrix_unique) (simp add: conv_matrix_def conv_ext_real_def)

text {*
The regular matrices are those which contain only @{text bot} or @{text top} entries.
*}

lemma regular_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_p_algebra.regular f \<longleftrightarrow> (\<forall>e . f e = bot \<or> f e = top)"
proof -
  have "matrix_p_algebra.regular f \<longleftrightarrow> (\<ominus>\<ominus>f = f)"
    by auto
  also have "... \<longleftrightarrow> (\<forall>e . --f e = f e)"
    by (metis uminus_matrix_def ext)
  also have "... \<longleftrightarrow> (\<forall>e . f e = bot \<or> f e = top)"
    by (metis ext_real_regular)
  finally show ?thesis
    .
qed

text {*
Vectors are precisely the row-constant matrices.
*}

lemma vector_ext_real_matrix_0:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_bounded_idempotent_semiring.vector f"
    shows "f (i,j) = (\<Squnion>\<^sub>k f (i,k))"
  by (metis assms comp_top_ext_real_matrix)

lemma vector_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_bounded_idempotent_semiring.vector f"
    shows "f (i,j) = f (i,k)"
  by (metis assms vector_ext_real_matrix_0)

lemma vector_ext_real_matrix_2:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<forall>i j k . f (i,j) = f (i,k)"
    shows "matrix_bounded_idempotent_semiring.vector f"
proof (rule ext, rule prod_cases)
  fix i j
  have "(f \<odot> mtop) (i,j) = (\<Squnion>\<^sub>k f (i,k))"
    by (simp add: comp_top_ext_real_matrix)
  also have "... = f (i,j)"
    by (metis assms ext_real_finite_sup_selective)
  finally show "(f \<odot> mtop) (i,j) = f (i,j)"
    .
qed

lemma vector_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_bounded_idempotent_semiring.vector f \<longleftrightarrow> (\<forall>i j k . f (i,j) = f (i,k))"
  using vector_ext_real_matrix_1 vector_ext_real_matrix_2 by auto

text {*
Hence covectors are precisely the column-constant matrices.
*}

lemma covector_ext_real_matrix_0:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_bounded_idempotent_semiring.covector f"
    shows "f (i,j) = (\<Squnion>\<^sub>k f (k,j))"
  by (metis assms top_comp_ext_real_matrix)

lemma covector_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_bounded_idempotent_semiring.covector f \<longleftrightarrow> (\<forall>i j k . f (i,j) = f (k,j))"
  by (unfold matrix_stone_relation_algebra.covector_conv_vector vector_ext_real_matrix) (metis (no_types, lifting) case_prod_conv id_def conv_matrix_def conv_ext_real_def)

text {*
A point is a matrix that has exactly one row, which is constant @{text top}, and all other rows are constant @{text bot}.
*}

lemma point_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.point f \<longleftrightarrow> (\<exists>i . \<forall>j . f (i,j) = top \<and> (\<forall>k . i \<noteq> k \<longrightarrow> f (k,j) = bot))"
  apply (unfold vector_ext_real_matrix bijective_ext_real_matrix)
  apply (rule iffI)
  apply metis
  by metis

lemma point_ext_real_matrix_unique:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.point f \<longleftrightarrow> (\<exists>!i . \<forall>j . f (i,j) = top \<and> (\<forall>k . i \<noteq> k \<longrightarrow> f (k,j) = bot))"
  apply (unfold vector_ext_real_matrix bijective_ext_real_matrix)
  apply (rule iffI)
  apply (metis bot_ext_real_def ext_real.simps(4) top_ext_real_def)
  by metis

lemma pp_point_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.pp_point f \<longleftrightarrow> (\<exists>i . \<forall>j . f (i,j) \<noteq> bot \<and> (\<forall>k . f (i,j) = f (i,k)) \<and> (\<forall>k . i \<noteq> k \<longrightarrow> f (k,j) = bot))"
  apply (unfold vector_ext_real_matrix pp_bijective_ext_real_matrix)
  apply (rule iffI)
  apply metis
  by metis

lemma pp_point_ext_real_matrix_unique:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.pp_point f \<longleftrightarrow> (\<exists>!i . \<forall>j . f (i,j) \<noteq> bot \<and> (\<forall>k . f (i,j) = f (i,k)) \<and> (\<forall>k . i \<noteq> k \<longrightarrow> f (k,j) = bot))"
  apply (unfold vector_ext_real_matrix pp_bijective_ext_real_matrix)
  apply (rule iffI)
  apply (metis bot_ext_real_def)
  by metis

text {*
An atom is a matrix that has exactly one @{text top} entry and all other entries are @{text bot}.
*}

lemma atom_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_stone_relation_algebra.atom f"
    shows "\<exists>e . f e = top \<and> (\<forall>d . e \<noteq> d \<longrightarrow> f d = bot)"
proof -
  have "matrix_stone_relation_algebra.point (f \<odot> mtop)"
    by (simp add: assms matrix_bounded_idempotent_semiring.vector_mult_closed)
  from this obtain i where 1: "\<forall>j . (f \<odot> mtop) (i,j) = top \<and> (\<forall>k . i \<noteq> k \<longrightarrow> (f \<odot> mtop) (k,j) = bot)"
    using point_ext_real_matrix by blast
  have "matrix_stone_relation_algebra.point (f\<^sup>t \<odot> mtop)"
    by (simp add: assms matrix_bounded_idempotent_semiring.vector_mult_closed)
  from this obtain j where "\<forall>i . (f\<^sup>t \<odot> mtop) (j,i) = top \<and> (\<forall>k . j \<noteq> k \<longrightarrow> (f\<^sup>t \<odot> mtop) (k,i) = bot)"
    using point_ext_real_matrix by blast
  hence 2: "\<forall>i . (mtop \<odot> f) (i,j) = top \<and> (\<forall>k . j \<noteq> k \<longrightarrow> (mtop \<odot> f) (i,k) = bot)"
    by (metis (no_types) id_apply old.prod.case conv_matrix_def conv_ext_real_def matrix_stone_relation_algebra.conv_dist_comp matrix_stone_relation_algebra.conv_top)
  have 3: "\<forall>i k . j \<noteq> k \<longrightarrow> f (i,k) = bot"
  proof (intro allI, rule impI)
    fix i k
    assume "j \<noteq> k"
    hence "(\<Squnion>\<^sub>l f (l,k)) = bot"
      using 2 by (simp add: top_comp_ext_real_matrix)
    thus "f (i,k) = bot"
      by (metis bot.extremum_uniqueI comp_inf.ub_sum)
  qed
  have "(\<Squnion>\<^sub>k f (i,k)) = top"
    using 1 by (simp add: comp_top_ext_real_matrix)
  hence 4: "f (i,j) = top"
    using 3 by (metis bot_ext_real_def ext_real.simps(4) ext_real_finite_sup_selective top_ext_real_def)
  have "\<forall>k l . k \<noteq> i \<or> l \<noteq> j \<longrightarrow> f (k,l) = bot"
  proof (intro allI, unfold imp_disjL, rule conjI)
    fix k l
    show "k \<noteq> i \<longrightarrow> f (k,l) = bot"
    proof
      assume "k \<noteq> i"
      hence "(\<Squnion>\<^sub>m f (k,m)) = bot"
        using 1 by (simp add: comp_top_ext_real_matrix)
      thus "f (k,l) = bot"
        by (metis bot.extremum_uniqueI comp_inf.ub_sum)
    qed
    show "l \<noteq> j \<longrightarrow> f (k,l) = bot"
      using 3 by simp
  qed
  thus ?thesis using 4
    by (metis old.prod.exhaust)
qed

lemma pp_atom_ext_real_matrix_2:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<exists>e . f e \<noteq> bot \<and> (\<forall>d . e \<noteq> d \<longrightarrow> f d = bot)"
    shows "matrix_stone_relation_algebra.pp_atom f"
proof (unfold matrix_stone_relation_algebra.pp_atom_expanded, intro conjI)
  show "f \<odot> mtop \<odot> f\<^sup>t \<preceq> mone"
  proof (unfold less_eq_matrix_def, rule allI, rule prod_cases)
    fix i j
    show "(f \<odot> mtop \<odot> f\<^sup>t) (i,j) \<le> mone (i,j)"
    proof (cases "i = j")
      assume "i = j"
      thus ?thesis
        by (simp add: one_matrix_def one_ext_real_def)
    next
      assume "i \<noteq> j"
      hence 1: "\<forall>k l . f (i,k) * f (j,l) = bot"
        by (metis assms Pair_inject semiring.mult_not_zero)
      have "(f \<odot> mtop \<odot> f\<^sup>t) (i,j) = (\<Squnion>\<^sub>l (f \<odot> mtop) (i,l) * (f\<^sup>t) (l,j))"
        by (simp add: times_matrix_def)
      also have "... = (\<Squnion>\<^sub>l (f \<odot> mtop) (i,l) * f (j,l))"
        by (simp add: conv_matrix_def conv_ext_real_def)
      also have "... = (\<Squnion>\<^sub>l (\<Squnion>\<^sub>k f (i,k)) * f (j,l))"
        by (simp add: comp_top_ext_real_matrix)
      also have "... = (\<Squnion>\<^sub>l \<Squnion>\<^sub>k f (i,k) * f (j,l))"
        by (metis inf_right_dist_sum times_ext_real_def)
      also have "... = bot"
        using 1 ext_real_finite_sup_selective by simp
      finally show ?thesis
        by simp
    qed
  qed
next
  show "f\<^sup>t \<odot> mtop \<odot> f \<preceq> mone"
  proof (unfold less_eq_matrix_def, rule allI, rule prod_cases)
    fix i j
    show "(f\<^sup>t \<odot> mtop \<odot> f) (i,j) \<le> mone (i,j)"
    proof (cases "i = j")
      assume "i = j"
      thus ?thesis
        by (simp add: one_matrix_def one_ext_real_def)
    next
      assume "i \<noteq> j"
      hence 2: "\<forall>k l . f (k,i) * f (l,j) = bot"
        by (metis assms Pair_inject semiring.mult_not_zero)
      have "(f\<^sup>t \<odot> mtop \<odot> f) (i,j) = (\<Squnion>\<^sub>l (f\<^sup>t \<odot> mtop) (i,l) * f (l,j))"
        by (simp add: times_matrix_def)
      also have "... = (\<Squnion>\<^sub>l (\<Squnion>\<^sub>k (f\<^sup>t) (i,k)) * f (l,j))"
        by (simp add: comp_top_ext_real_matrix)
      also have "... = (\<Squnion>\<^sub>l (\<Squnion>\<^sub>k f (k,i)) * f (l,j))"
        by (simp add: conv_matrix_def conv_ext_real_def)
      also have "... = (\<Squnion>\<^sub>l \<Squnion>\<^sub>k f (k,i) * f (l,j))"
        by (metis inf_right_dist_sum times_ext_real_def)
      also have "... = bot"
        using 2 ext_real_finite_sup_selective by simp
      finally show ?thesis
        by simp
    qed
  qed
next
  show "mtop \<odot> \<ominus>\<ominus>f \<odot> mtop = mtop"
  proof (rule ext, rule prod_cases)
    fix i j
    from assms obtain k l where "f (k,l) \<noteq> bot"
      using prod.collapse by auto
    hence "top = --f (k,l)"
      by (simp add: ext_real_dense)
    also have "... \<le> (\<Squnion>\<^sub>k --f (k,l))"
      using comp_inf.ub_sum by simp
    also have "... \<le> (\<Squnion>\<^sub>l \<Squnion>\<^sub>k --f (k,l))"
      using comp_inf.ub_sum by simp
    finally have 3: "top \<le> (\<Squnion>\<^sub>l \<Squnion>\<^sub>k --f (k,l))"
      by simp
    have "(mtop \<odot> \<ominus>\<ominus>f \<odot> mtop) (i,j) = (\<Squnion>\<^sub>l (\<Squnion>\<^sub>k top * --f (k,l)) * top)"
      by (simp add: times_matrix_def top_matrix_def uminus_matrix_def)
    also have "... = (\<Squnion>\<^sub>l \<Squnion>\<^sub>k --f (k,l))"
      using one_ext_real_def by auto
    also have "... = top"
      using 3 top.extremum_unique by blast
    finally show "(mtop \<odot> \<ominus>\<ominus>f \<odot> mtop) (i,j) = mtop (i,j)"
      by (simp add: top_matrix_def)
  qed
qed

lemma atom_ext_real_matrix_2:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<exists>e . f e = top \<and> (\<forall>d . e \<noteq> d \<longrightarrow> f d = bot)"
    shows "matrix_stone_relation_algebra.atom f"
proof (unfold matrix_stone_relation_algebra.atom_expanded, intro conjI)
  show "f \<odot> mtop \<odot> f\<^sup>t \<preceq> mone"
    by (metis assms bot_ext_real_def ext_real.simps(5) matrix_stone_relation_algebra.pp_atom_expanded pp_atom_ext_real_matrix_2 top_ext_real_def)
next
  show "f\<^sup>t \<odot> mtop \<odot> f \<preceq> mone"
    by (metis assms bot_ext_real_def ext_real.simps(5) matrix_stone_relation_algebra.pp_atom_expanded pp_atom_ext_real_matrix_2 top_ext_real_def)
next
  show "mtop \<odot> f \<odot> mtop = mtop"
  proof (rule ext, rule prod_cases)
    fix i j
    from assms obtain k l where "f (k,l) = top"
      using prod.collapse by auto
    hence "(\<Squnion>\<^sub>k f (k,l)) = top"
      by (metis (mono_tags) comp_inf.ub_sum top_unique)
    hence 3: "top \<le> (\<Squnion>\<^sub>l \<Squnion>\<^sub>k f (k,l))"
      by (metis (no_types) comp_inf.ub_sum)
    have "(mtop \<odot> f \<odot> mtop) (i,j) = (\<Squnion>\<^sub>l (\<Squnion>\<^sub>k top * f (k,l)) * top)"
      by (simp add: times_matrix_def top_matrix_def)
    also have "... = (\<Squnion>\<^sub>l \<Squnion>\<^sub>k f (k,l))"
      using one_ext_real_def by auto
    also have "... = top"
      using 3 top.extremum_unique by blast
    finally show "(mtop \<odot> f \<odot> mtop) (i,j) = mtop (i,j)"
      by (simp add: top_matrix_def)
  qed
qed

lemma atom_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.atom f \<longleftrightarrow> (\<exists>e . f e = top \<and> (\<forall>d . e \<noteq> d \<longrightarrow> f d = bot))"
  using atom_ext_real_matrix_1 atom_ext_real_matrix_2 by blast

lemma atom_ext_real_matrix_unique:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.atom f \<longleftrightarrow> (\<exists>!e . f e = top \<and> (\<forall>d . e \<noteq> d \<longrightarrow> f d = bot))"
  apply (rule iffI)
  apply (metis (no_types, hide_lams) atom_ext_real_matrix bot_ext_real_def ext_real.simps(4) top_ext_real_def)
  using atom_ext_real_matrix by blast

lemma pp_atom_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_stone_relation_algebra.pp_atom f"
    shows "\<exists>e . f e \<noteq> bot \<and> (\<forall>d . e \<noteq> d \<longrightarrow> f d = bot)"
proof -
  have "matrix_stone_relation_algebra.pp_point (f \<odot> mtop)"
    by (simp add: assms matrix_bounded_idempotent_semiring.vector_mult_closed)
  from this obtain i where 1: "\<forall>j . (f \<odot> mtop) (i,j) \<noteq> bot \<and> (\<forall>k . (f \<odot> mtop) (i,j) = (f \<odot> mtop) (i,k)) \<and> (\<forall>k . i \<noteq> k \<longrightarrow> (f \<odot> mtop) (k,j) = bot)"
    by (metis pp_point_ext_real_matrix)
  have "matrix_stone_relation_algebra.pp_point (f\<^sup>t \<odot> mtop)"
    by (simp add: assms matrix_bounded_idempotent_semiring.vector_mult_closed)
  from this obtain j where "\<forall>i . (f\<^sup>t \<odot> mtop) (j,i) \<noteq> bot \<and> (\<forall>k . (f\<^sup>t \<odot> mtop) (j,i) = (f\<^sup>t \<odot> mtop) (j,k)) \<and> (\<forall>k . j \<noteq> k \<longrightarrow> (f\<^sup>t \<odot> mtop) (k,i) = bot)"
    by (metis pp_point_ext_real_matrix)
  hence 2: "\<forall>i . (mtop \<odot> f) (i,j) \<noteq> bot \<and> (\<forall>k . (mtop \<odot> f) (i,j) = (mtop \<odot> f) (k,j)) \<and> (\<forall>k . j \<noteq> k \<longrightarrow> (mtop \<odot> f) (i,k) = bot)"
    by (metis (no_types) id_apply old.prod.case conv_matrix_def conv_ext_real_def matrix_stone_relation_algebra.conv_dist_comp matrix_stone_relation_algebra.conv_top)
  have 3: "\<forall>i k . j \<noteq> k \<longrightarrow> f (i,k) = bot"
  proof (intro allI, rule impI)
    fix i k
    assume "j \<noteq> k"
    hence "(\<Squnion>\<^sub>l f (l,k)) = bot"
      using 2 by (simp add: top_comp_ext_real_matrix)
    thus "f (i,k) = bot"
      by (metis bot.extremum_uniqueI comp_inf.ub_sum)
  qed
  have "(\<Squnion>\<^sub>k f (i,k)) \<noteq> bot"
    using 1 by (simp add: comp_top_ext_real_matrix)
  hence 4: "f (i,j) \<noteq> bot"
    using 3 by (metis bot_ext_real_def ext_real_finite_sup_selective)
  have "\<forall>k l . k \<noteq> i \<or> l \<noteq> j \<longrightarrow> f (k,l) = bot"
  proof (intro allI, unfold imp_disjL, rule conjI)
    fix k l
    show "k \<noteq> i \<longrightarrow> f (k,l) = bot"
    proof
      assume "k \<noteq> i"
      hence "(\<Squnion>\<^sub>m f (k,m)) = bot"
        using 1 by (simp add: comp_top_ext_real_matrix)
      thus "f (k,l) = bot"
        by (metis bot.extremum_uniqueI comp_inf.ub_sum)
    qed
    show "l \<noteq> j \<longrightarrow> f (k,l) = bot"
      using 3 by simp
  qed
  thus ?thesis using 4
    by (metis old.prod.exhaust)
qed

lemma pp_atom_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.pp_atom f \<longleftrightarrow> (\<exists>e . f e \<noteq> bot \<and> (\<forall>d . e \<noteq> d \<longrightarrow> f d = bot))"
  using pp_atom_ext_real_matrix_1 pp_atom_ext_real_matrix_2 by blast

lemma pp_atom_ext_real_matrix_unique:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.pp_atom f \<longleftrightarrow> (\<exists>!e . f e \<noteq> bot \<and> (\<forall>d . e \<noteq> d \<longrightarrow> f d = bot))"
  apply (rule iffI)
  apply (metis (no_types, hide_lams) pp_atom_ext_real_matrix bot_ext_real_def)
  using pp_atom_ext_real_matrix by blast

text {*
Reflexive matrices are those with a constant @{text top} diagonal.
*}

lemma reflexive_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_idempotent_semiring.reflexive f"
    shows "f (i,i) = top"
proof -
  have "(top::ext_real) = mone (i,i)"
    by (simp add: one_matrix_def one_ext_real_def)
  also have "... \<le> f (i,i)"
    using assms less_eq_matrix_def by blast
  finally show ?thesis
    by (simp add: top.extremum_unique)
qed

lemma reflexive_ext_real_matrix_2:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<forall>i . f (i,i) = top"
    shows "matrix_idempotent_semiring.reflexive f"
proof (unfold less_eq_matrix_def, rule allI, rule prod_cases)
  fix i j
  show "mone (i,j) \<le> f (i,j)"
  proof (cases "i = j")
    assume "i = j"
    thus ?thesis
      by (simp add: assms)
  next
    assume "i \<noteq> j"
    hence "(bot::ext_real) = mone (i,j)"
      by (simp add: one_matrix_def)
    thus ?thesis
      by simp
  qed
qed

lemma reflexive_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_idempotent_semiring.reflexive f \<longleftrightarrow> (\<forall>i . f (i,i) = top)"
  using reflexive_ext_real_matrix_1 reflexive_ext_real_matrix_2 by auto

text {*
Coreflexive matrices are those in which all non-diagonal entries are @{text bot}.
*}

lemma coreflexive_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_idempotent_semiring.coreflexive f"
      and "i \<noteq> j"
    shows "f (i,j) = bot"
proof -
  have "f (i,j) \<le> mone (i,j)"
    using assms less_eq_matrix_def by blast
  also have "... = bot"
    by (simp add: assms one_matrix_def)
  finally show ?thesis
    by (simp add: bot.extremum_unique)
qed

lemma coreflexive_ext_real_matrix_2:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<forall>i j . i \<noteq> j \<longrightarrow> f (i,j) = bot"
    shows "matrix_idempotent_semiring.coreflexive f"
proof (unfold less_eq_matrix_def, rule allI, rule prod_cases)
  fix i j
  show "f (i,j) \<le> mone (i,j)"
  proof (cases "i = j")
    assume "i = j"
    hence "(top::ext_real) = mone (i,j)"
      by (simp add: one_matrix_def one_ext_real_def)
    thus ?thesis
      by simp
  next
    assume "i \<noteq> j"
    thus ?thesis
      by (simp add: assms)
  qed
qed

lemma coreflexive_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_idempotent_semiring.coreflexive f \<longleftrightarrow> (\<forall>i j . i \<noteq> j \<longrightarrow> f (i,j) = bot)"
  using coreflexive_ext_real_matrix_1 coreflexive_ext_real_matrix_2 by auto

text {*
Irreflexive matrices are those with a constant @{text bot} diagonal.
*}

lemma irreflexive_ext_real_matrix_1:
  fixes f :: "'a::finite ext_real_square"
  assumes "matrix_stone_relation_algebra.irreflexive f"
    shows "f (i,i) = bot"
proof -
  have "(top::ext_real) = mone (i,i)"
    by (simp add: one_matrix_def one_ext_real_def)
  hence "(bot::ext_real) = (\<ominus>mone) (i,i)"
    by (simp add: uminus_matrix_def)
  hence "f (i,i) \<le> bot"
    by (metis assms less_eq_matrix_def)
  thus ?thesis
    by (simp add: bot.extremum_unique)
qed

lemma irreflexive_ext_real_matrix_2:
  fixes f :: "'a::finite ext_real_square"
  assumes "\<forall>i . f (i,i) = bot"
    shows "matrix_stone_relation_algebra.irreflexive f"
proof (unfold less_eq_matrix_def, rule allI, rule prod_cases)
  fix i j
  show "f (i,j) \<le> (\<ominus>mone) (i,j)"
  proof (cases "i = j")
    assume "i = j"
    thus ?thesis
      by (simp add: assms)
  next
    assume "i \<noteq> j"
    hence "(bot::ext_real) = mone (i,j)"
      by (simp add: one_matrix_def)
    hence "(top::ext_real) = (\<ominus>mone) (i,j)"
      by (simp add: uminus_matrix_def)
    thus ?thesis
      by simp
  qed
qed

lemma irreflexive_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.irreflexive f \<longleftrightarrow> (\<forall>i . f (i,i) = bot)"
  using irreflexive_ext_real_matrix_1 irreflexive_ext_real_matrix_2 by auto

text {*
As usual, symmetric matrices are those which do not change under transposition.
*}

lemma symmetric_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.symmetric f \<longleftrightarrow> (\<forall>i j . f (i,j) = f (j,i))"
  by (metis (mono_tags, lifting) case_prod_conv cond_case_prod_eta id_def conv_matrix_def conv_ext_real_def)

text {*
Antisymmetric matrices are characterised as follows: each entry not on the diagonal or its mirror entry across the diagonal must be @{text bot}.
*}

lemma antisymmetric_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.antisymmetric f \<longleftrightarrow> (\<forall>i j . i \<noteq> j \<longrightarrow> f (i,j) = bot \<or> f (j,i) = bot)"
proof -
  have "matrix_stone_relation_algebra.antisymmetric f \<longleftrightarrow> (\<forall>i j . i \<noteq> j \<longrightarrow> f (i,j) \<sqinter> f (j,i) \<le> bot)"
    by (simp add: conv_matrix_def inf_matrix_def conv_ext_real_def less_eq_matrix_def one_matrix_def one_ext_real_def)
  thus ?thesis
    by (metis bot.extremum_uniqueI ext_real_bot_product inf.order_refl semiring.mult_not_zero times_ext_real_def)
qed

text {*
For asymmetric matrices the diagonal is included: each entry or its mirror entry across the diagonal must be @{text bot}.
*}

lemma asymmetric_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_stone_relation_algebra.asymmetric f \<longleftrightarrow> (\<forall>i j . f (i,j) = bot \<or> f (j,i) = bot)"
proof -
  have "matrix_stone_relation_algebra.asymmetric f \<longleftrightarrow> (\<forall>i j . f (i,j) \<sqinter> f (j,i) \<le> bot)"
    apply (unfold conv_matrix_def inf_matrix_def conv_ext_real_def id_def bot_matrix_def)
    by (metis (mono_tags, lifting) bot.extremum bot.extremum_uniqueI case_prod_conv old.prod.exhaust)
  thus ?thesis
    by (metis bot.extremum_uniqueI ext_real_bot_product inf.order_refl semiring.mult_not_zero times_ext_real_def)
qed

text {*
In a transitive matrix, the weight of one of the edges on an indirect route must be below the weight of the direct edge.
*}

lemma transitive_ext_real_matrix:
  fixes f :: "'a::finite ext_real_square"
  shows "matrix_idempotent_semiring.transitive f \<longleftrightarrow> (\<forall>i j k . f (i,k) \<le> f (i,j) \<or> f (k,j) \<le> f (i,j))"
proof -
  have "matrix_idempotent_semiring.transitive f \<longleftrightarrow> (\<forall>i j . (\<Squnion>\<^sub>k f (i,k) * f (k,j)) \<le> f (i,j))"
    by (simp add: times_matrix_def less_eq_matrix_def)
  also have "... \<longleftrightarrow> (\<forall>i j k . f (i,k) * f (k,j) \<le> f (i,j))"
    by (simp add: lub_sum_iff)
  also have "... \<longleftrightarrow> (\<forall>i j k . f (i,k) \<le> f (i,j) \<or> f (k,j) \<le> f (i,j))"
    by (simp add: times_ext_real_def ext_real_inf_less_eq)
  finally show ?thesis
    .
qed

text {*
We finally show the effect of composing with a coreflexive (test) from the left and from the right.
This amounts to a restriction of each row or column to the entry on the diagonal of the coreflexive.
In this case, restrictions are formed by meets.
*}

lemma coreflexive_comp_ext_real_matrix:
  fixes f g :: "'a::finite ext_real_square"
  assumes "matrix_idempotent_semiring.coreflexive f"
    shows "(f \<odot> g) (i,j) = f (i,i) \<sqinter> g (i,j)"
proof -
  have 1: "\<forall>k . i \<noteq> k \<longrightarrow> f (i,k) = bot"
    using assms coreflexive_ext_real_matrix by auto
  have "(\<Squnion>\<^sub>k f (i,k)) = f (i,i) \<squnion> (\<Squnion>\<^bsub>k\<in>UNIV-{i}\<^esub> f (i,k))"
    by (metis (no_types) UNIV_def brouwer.inf_bot_right finite_UNIV insert_def sup_monoid.sum.insert_remove)
  hence 2: "(\<Squnion>\<^sub>k f (i,k)) = f (i,i)"
    using 1 by (simp add: DiffD2 singletonI sup_monoid.sum.neutral)
  have "(f \<odot> g) (i,j) = (f \<odot> mtop \<otimes> g) (i,j)"
    by (metis assms matrix_stone_relation_algebra.coreflexive_comp_top_inf)
  also have "... = (\<Squnion>\<^sub>k f (i,k)) \<sqinter> g (i,j)"
    by (metis inf_matrix_def comp_top_ext_real_matrix)
  finally show ?thesis
    using 2 by simp
qed

lemma comp_coreflexive_ext_real_matrix:
  fixes f g :: "'a::finite ext_real_square"
  assumes "matrix_idempotent_semiring.coreflexive g"
    shows "(f \<odot> g) (i,j) = f (i,j) \<sqinter> g (j,j)"
proof -
  have "(f \<odot> g) (i,j) = ((f \<odot> g)\<^sup>t) (j,i)"
    by (simp add: conv_matrix_def conv_ext_real_def)
  also have "... = (g \<odot> f\<^sup>t) (j,i)"
    by (simp add: assms matrix_stone_relation_algebra.conv_dist_comp matrix_stone_relation_algebra.coreflexive_symmetric)
  also have "... = g (j,j) \<sqinter> (f\<^sup>t) (j,i)"
    by (simp add: assms coreflexive_comp_ext_real_matrix)
  also have "... = f (i,j) \<sqinter> g (j,j)"
    by (simp add: conv_matrix_def conv_ext_real_def inf_commute)
  finally show ?thesis
    .
qed

(*
lemma schroeder_3:
  fixes x :: "'a::finite ext_real_square"
  shows "x \<odot> y \<preceq> z \<longleftrightarrow> x\<^sup>t \<odot> \<ominus>z \<preceq> \<ominus>y"
  nitpick [card=3,card 'a=1,expect=potential] oops

lemma theorem24xxiv:
  fixes x :: "'a::finite ext_real_square"
  shows "\<ominus>(x \<odot> y) \<oplus> (x \<odot> z) = \<ominus>(x \<odot> (y \<otimes> \<ominus>z)) \<oplus> (x \<odot> z)"
  nitpick [card=3,card 'a=1,expect=potential] oops

lemma
  fixes x :: "'a::finite ext_real_square"
  assumes "matrix_bounded_idempotent_semiring.vector x"
    shows "\<ominus>(\<ominus>x \<odot> mtop) \<otimes> mone \<preceq> x"
  nitpick [card=3,card 'a=1,expect=potential] oops

lemma
  fixes x :: "'a::finite ext_real_square"
  assumes "matrix_bounded_idempotent_semiring.vector x"
    shows "(\<ominus>(\<ominus>x \<odot> mtop) \<otimes> mone) \<odot> mtop = x"
  nitpick [card=3,card 'a=1,expect=potential] oops

lemma complement_vector:
  fixes x :: "'a::finite ext_real_square"
  assumes "matrix_bounded_idempotent_semiring.vector (-x)"
    shows "matrix_bounded_idempotent_semiring.vector x"
  nitpick [card=4,card 'a=2,expect=potential] oops

lemma
  fixes x :: "'a::finite ext_real_square"
  assumes "x \<noteq> mbot"
    shows "\<ominus>x \<otimes> y = \<ominus>\<ominus>(\<ominus>x \<otimes> y)"
  nitpick [card 'a=2,expect=genuine]
*)

end
