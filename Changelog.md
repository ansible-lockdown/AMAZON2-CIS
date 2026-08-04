# AMAZON2-CIS Changelog

## July 2026 - Section 6 QA pass fixes

- Fixed 6.1.3-6.1.10 file/mode mismatch
- Fixed typos in 6.2.9 audit task names
- Fixed variable bugs in `lockdown_audit.yml.j2`
- moved some prelim tasks closer to the task file
- Converted all `ansible_facts.<key>` dot-notation to `ansible_facts['<key>']` bracket
- Confirmed section 2.2.x  ternary guard on `enabled`/`state`
- Added `amazon2cis_shell_executable: /bin/bash` to `vars/main.yml`; updated all
  `args.executable:`
- Handlers: removed unused `Systemd restart tmp.mount` and `Auditd rules reload` handlers
- Handlers: added missing `Restart_chronyd` handler (referenced in prelim.yml but absent)
- Linting: fixed `notify: restart sshd` to `notify: Restart sshd` in prelim.yml (case-sensitive match)
- Linting: moved `vars: warn_control_id:` from block-level to task-level on all
  `ansible.builtin.import_tasks: warning_facts.yml`
- Linting: converted octal file modes to symbolic format in cis_4.5.3.x.yml and cis_6.2.x.yml
- Templates: added `{{ file_managed_by_ansible }}` on line 1 of
  `templates/etc/systemd/system/tmp.mount.j2`
- Templates: deleted orphan templates `templates/ntp.conf.j2` and
  `templates/etc/tmp_mount.j2` (no tasks reference them)
- Meta: updated `min_ansible_version` from `2.11.1` to `2.16.1` in `meta/main.yml`
  and `vars/main.yml`
- Meta: corrected company name to `MindPoint Group - A Tyto Athene Company` in `meta/main.yml`
- Defaults: fixed wrong-role variable prefix in section 6 password quality setting
  (`ubtu22cis_pwquality_minclass_value` -> `amazon2cis_pwquality_minclass_value`)
- Defaults: fixed section 6 comment delimiter to match section structure convention
- LICENSE: fixed copyright casing `Mindpoint` -> `MindPoint`
- README: rebranded Twitter badge to X (`twitter.com` -> `x.com`); fixed grammar
- CONTRIBUTING.rst: fixed duplicate word typo
- `.gitignore`: added `qa_report.md`, `prompt.md`, `test_inv`
- Mount tasks 1.1.2.x.1 relabelled to AUDIT

---

## March 26 alignment v3.0.0

- Run all rules against Amazon/amazon2 folders
  - Common files alignment: LICENSE, CONTRIBUTING.rst, .github/workflows
  - Lint converted AMAZON2-CIS-Audit vars/CIS.yml from 4-space to 2-space
  - added missing variable definitions in defaults (amazon2cis_rule_1_1_3/4/5, amazon2cis_nft_tables_autoNewTable, amazon2cis_firewall_interface)
  - Updated to latest versions
  - Removed QA report md files
  - March26 align merge
  - Common files alignment: LICENSE, CONTRIBUTING, workflows, vars merge
  - CIS remediation validation: task titles and tags aligned to canonical; rule_3.4.1.2 tag fixed

---

Benchmark: v3.0.0. March Updates

## Remediation (AMAZON2-CIS)

- **6.1.x:** Paths and titles aligned for 6.1.3–6.1.10; 6.1.12 logic and content improved.
- **Section 2:** 2.1.12 updated for correct package.
- **Section 4:** 4.3.4 logic updated; 4.5.1.x var naming and controls updated (exclude connected user).
- **Section 5:** 5.1.4 improved.
- **Section 3:** Typo fix in 3.4.3.5; audit logic fixes.
- **Titles & tags:** Titles updated; tag/level fixes; spelling/typos fixed.
- **Variables:** Var naming aligned and standardised; vars moved to correct location.
- **Behaviour:** `skip_reboot` set to true; tmp and wifi discovery logic updated.
- **Audit/template:** Template added to auditd steps.
- **Linting:** YAML spacing, layout, and lint alignment; aligned with new standards.
- **Other:** Git ignore updated; handler name casing and lint updates.
