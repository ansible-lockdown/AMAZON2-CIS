# AMAZON2-CIS Changelog

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
