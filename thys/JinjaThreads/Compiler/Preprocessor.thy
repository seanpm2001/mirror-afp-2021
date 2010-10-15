theory Preprocessor 
imports 
  PCompiler
  "../J/Annotate"
  "../J/JWellForm"
begin

primrec annotate_Mb :: "J_prog \<Rightarrow> cname \<Rightarrow> mname \<Rightarrow> ty list \<Rightarrow> ty \<Rightarrow> (vname list \<times> expr) \<Rightarrow> (vname list \<times> expr)"
where "annotate_Mb P C M Ts T (pns, e) = (pns, annotate P [this # pns [\<mapsto>] Class C # Ts] e)"
declare annotate_Mb.simps [simp del]

primrec annotate_Mb_code :: "J_prog \<Rightarrow> cname \<Rightarrow> mname \<Rightarrow> ty list \<Rightarrow> ty \<Rightarrow> (vname list \<times> expr) \<Rightarrow> (vname list \<times> expr)"
where "annotate_Mb_code P C M Ts T (pns, e) = (pns, annotate_code P [this # pns [\<mapsto>] Class C # Ts] e)"
declare annotate_Mb_code.simps [simp del]

definition annotate_prog :: "J_prog \<Rightarrow> J_prog"
where "annotate_prog P = compP (annotate_Mb P) P"

definition annotate_prog_code :: "J_prog \<Rightarrow> J_prog"
where "annotate_prog_code P = compP (annotate_Mb_code P) P"

lemma WT_compP: "P,E \<turnstile> e :: T \<Longrightarrow> compP f P,E \<turnstile> e :: T"
  and WTs_compP: "P,E \<turnstile> es [::] Ts \<Longrightarrow> compP f P,E \<turnstile> es [::] Ts"
proof(induct rule: WT_WTs.inducts)
  case (WTCall E e C M Ts T pns body D es Ts')
  from `P \<turnstile> C sees M: Ts\<rightarrow>T = (pns, body) in D`
  have "compP f P \<turnstile> C sees M: Ts\<rightarrow>T = (fst (f D M Ts T (pns, body)), snd (f D M Ts T (pns, body))) in D"
    by(auto dest: sees_method_compP[where f=f])
  with WTCall show ?case by(auto simp del: pair_collapse)
qed(auto simp del: fun_upd_apply)

lemma Anno_compP: "P,E \<turnstile> e \<leadsto> e' \<Longrightarrow> compP f P,E \<turnstile> e \<leadsto> e'"
  and Annos_compP: "P,E \<turnstile> es [\<leadsto>] es' \<Longrightarrow> compP f P,E \<turnstile> es [\<leadsto>] es'"
apply(induct rule: Anno_Annos.inducts)
apply(auto intro: Anno_Annos.intros simp del: fun_upd_apply dest: WT_compP simp add: compC_def)
done

lemma assumes wf: "wf_J_prog (annotate_prog_code P)"
  shows "annotate_prog_code P = annotate_prog P"
proof -
  let ?wf_md = "\<lambda>_ _ (_,_,_,_,body). set (block_types body) \<subseteq> types P"
  from wf have "wf_prog ?wf_md (annotate_prog_code P)"
    unfolding annotate_prog_code_def
    by(rule wf_prog_lift)(auto dest!: WT_block_types_is_type[OF wf[unfolded annotate_prog_code_def]] simp add: wf_J_mdecl_def)
  hence wf': "wf_prog ?wf_md P"
    unfolding annotate_prog_code_def_raw
  proof(rule wf_prog_compPD)
    fix C M Ts T m
    assume "compP (annotate_Mb_code P) P \<turnstile> C sees M: Ts\<rightarrow>T = annotate_Mb_code P C M Ts T m in C"
      and "wf_mdecl ?wf_md (compP (annotate_Mb_code P) P) C (M, Ts, T, annotate_Mb_code P C M Ts T m)"
    moreover obtain pns body where "m = (pns, body)" by(cases m)
    ultimately show "wf_mdecl ?wf_md P C (M, Ts, T, m)"
      by(fastsimp simp add: annotate_Mb_code_def annotate_code_def wf_mdecl_def THE_default_def the_equality split: split_if_asm dest: Anno_code_block_types)
  qed

  { fix C D fs ms M Ts T pns body
    assume "(C, D, fs, ms) \<in> set P"
      and "(M, Ts, T, pns, body) \<in> set ms"
    with wf' have sees: "P \<turnstile> C sees M:Ts\<rightarrow>T = (pns, body) in C"
      by(rule mdecl_visible)

    from sees_method_compP[OF this, where f="annotate_Mb_code P"]
    have sees': "annotate_prog_code P \<turnstile> C sees M:Ts\<rightarrow>T = (pns, annotate_code P [this \<mapsto> Class C, pns [\<mapsto>] Ts] body) in C"
      unfolding annotate_prog_code_def annotate_Mb_code_def by(auto)
    with wf
    have "wf_mdecl wf_J_mdecl (annotate_prog_code P) C (M, Ts, T, pns, annotate_code P [this \<mapsto> Class C, pns [\<mapsto>] Ts] body)"
      by(rule sees_wf_mdecl)
    hence "set Ts \<subseteq> types P" by(auto simp add: wf_mdecl_def annotate_prog_code_def)
    moreover from sees have "is_class P C" by(rule sees_method_is_class)
    moreover from wf' sees have "wf_mdecl ?wf_md P C (M, Ts, T, pns, body)" by(rule sees_wf_mdecl)
    hence "set (block_types body) \<subseteq> types P" by(simp add: wf_mdecl_def)
    ultimately have "ran [this \<mapsto> Class C, pns [\<mapsto>] Ts] \<union> set (block_types body) \<subseteq> types P"
      by(auto simp add: ran_def wf_mdecl_def map_upds_def split: split_if_asm dest!: map_of_SomeD set_zip_rightD)
    hence "annotate_code P [this \<mapsto> Class C, pns [\<mapsto>] Ts] body = annotate P [this \<mapsto> Class C, pns [\<mapsto>] Ts] body"
      unfolding annotate_code_def annotate_def
      by -(rule arg_cong[where f="THE_default body"], auto intro!: ext intro: Anno_code_into_Anno[OF wf'] Anno_into_Anno_code[OF wf']) }
  thus ?thesis unfolding annotate_prog_code_def annotate_prog_def compP_def
    by(auto simp add: compC_def compM_def annotate_Mb_def annotate_Mb_code_def)
qed


end

