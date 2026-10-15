# AMAZON2-CIS Changelog

## CIS Benchmark 4.0.0 - final release, Amazon Linux 2 is end of life
## October 2026 - QA fixes

- prelim: IPv6 sshd/chronyd and auditd extra-conf tasks no longer tagged always
- prelim: boot type detected before the pre-remediation audit
- 1.4.1.3/1.4.1.4: either toggle runs the SELinux task
- /tmp: remount_tmp.yml aligned, tmp.mount enabled on reload
- /tmp: busy-mount warning fixed
- /tmp: amazon2cis_tmp_svc accepts auto
- 6.1.1.1: tagged patch
- injected facts replaced with ansible_facts
- company name updated to Quantum Sky
- gitleaks pinned to v8.30.0
- README: Known Issues control IDs corrected

## Benchmark v4.0.0

## sept_auditd_update (Private-AMAZON2-CIS) based on v4.0.0

- sept_auditd_update branch
  - fixed the collection of audit privileged commands

## August 2026 - Audit variables moved to defaults/main/audit.yml

Audit variables were held in `vars/audit.yml`, which outranks inventory, group_vars,
host_vars and molecule - so every override a user or molecule set was silently ignored.
Moved to the split defaults layout so they sit at defaults precedence and are overridable.

- `vars/audit.yml` -> `defaults/main/audit.yml`; `defaults/main.yml` -> `defaults/main/main.yml`
- the overridable audit vars (setup_audit, run_audit, audit_only, audit_run_heavy_tests,
  fetch_audit_output, audit_output_collection_method, audit_log_dir, audit_output_destination)
  moved out of main.yml so all audit variables sit in one file
- removed the `PRELIM | Include audit specific variables` task - `defaults/main/` is
  auto-loaded, so the include_vars is redundant and would reintroduce the precedence problem
- verified no variable lost or duplicated: 491 keys before (471 defaults + 20 vars/audit),
  491 after, none gained, none lost
- verified on a live host: an inventory-level override of `audit_conf_dest` now takes effect
  (audit content landed at `/opt/splittest/AMAZON2-CIS-Audit`); before the move this was
  ignored. Role converged 391 ok / 0 failed with the new layout
- README updates and updated contributing and contributors

### Audit repo goss fixes found by the first real goss run

Running the audit against local v4.0.0 content (`audit_content: copy`) exercised the goss
tests for the first time - 710 tests, 61 failures, of which two were test defects:

- 2.1.3 asserted the literal string `OPTIONS="-u chrony"` but AL2 ships
  `OPTIONS="-F 2 -u chrony"`, so a compliant host failed. Now a regex
- 6.3.3 regexes were double-escaped (`\\s`, `\\+`) and wrapped in `/.../` while containing
  unescaped `/` in the `/sbin/...` paths, so they could never match. Now plain substrings

The remaining 59 failures are host state, not defects - 44 are the separate-partition
controls on a single-disk host, plus SELinux (userspace tools absent), 4.1.8 (drop-all
deliberately not applied) and controls needing a reboot.

## August 2026 - QA pass on real Amazon Linux 2 host

Full QA run against a live Amazon Linux 2 host (molecule unavailable - Docker daemon down).
Coverage, toggle parity, titles, level profile, lint and cross-repo alignment all clean.
Remediation converged 404 ok / 0 failed and is idempotent by the third pass, with only the
timestamped compliance facts file changing.

- README.md: every badge pointed at the non-existent `ansible-lockdown/AMZN2-CIS` and
  `badges/Private-AMZN2-CIS/` paths, so all 16 rendered as "repo not found" / "resource not
  found". Corrected to AMAZON2; all 23 shields.io badges and both Actions badges now render.
  The `#GH_AL_AMZN2*` marketing anchors are deliberately left alone - other roles abbreviate
  the same way (`GH_AL_RH8_cis`)
- README.md: X badge image URL moved from twitter.com to x.com, matching RHEL9
- tasks/main.yml: root password pre-check accepted only the spelled-out `passwd -S` wording,
  so on stock AL2 - which prints the short `LK`/`PS` status codes - the assert aborted the
  whole play before any control ran. Pattern extended to accept the status codes, and the
  deprecated `egrep` replaced with `grep -E`
- section_4/cis_4.1.x.yml: 4.1.3 discovery piped stdout to grep, but firewall-cmd writes
  `no zone` to stderr, so no unassigned interface was ever detected and the control silently
  did nothing while reporting ok. Now keyed off the command exit status
- section_6/cis_6.1.1.x.yml: 6.1.1.2 used `state: stopped` against
  systemd-journal-remote.socket, which does not exist on AL2, failing the play and making the
  whole journald path unreachable. Now uses the package-presence ternary convention already
  used by the section 2 masking tasks
- section_6/cis_6.1.1.x.yml: blocks reordered numerically - 6.1.1.2 preceded 6.1.1.1
- handlers/main.yml: removed Restart_systemd_journal_upload, orphaned when the
  systemd-journal-remote controls were retired
- vars/audit.yml: audit_git_version now strips the leading v so it resolves to
  benchmark_4.0.0, matching the audit branch naming convention going forward
- templates/lockdown_audit.yml.j2: added amazon2cis_active_firewall_zone and
  amazon2cis_pass_min_days, referenced by the new goss tests but not previously bridged

### Audit repo fixes

- section_2/cis_2.1/cis_2.1.3.yml: block was missing its `file:` resource type, so the
  control parsed as an unknown resource and had never asserted anything
- section_4/cis_4.1/cis_4.1.3.yml and cis_4.1.7.yml: rewritten - both had a doubled `---`
  marker and no resource type; 4.1.3 also had an unbalanced quote in its exec string and the
  same stderr bug as the remediation task, and 4.1.7 asserted `!/Warning/` against a command
  that always echoes "Warning", so it could never pass
- vars/CIS.yml: added amazon2cis_active_firewall_zone and amazon2cis_pass_min_days

## August 2026 - CIS Amazon Linux 2 Benchmark v3.0.0 -> v4.0.0 upgrade

Full section restructure to the v4.0.0 layout - 289 controls become 287, across seven sections.

### Section restructure

- Section 4 (Access/Authentication) -> section 5; section 5 (Logging and Auditing) -> section 6; section 6 (System Maintenance) -> section 7
- New section 4 (Host Based Firewall) holds the firewalld controls, moved from 3.4.2.x
- Section 4 is firewalld only - all 21 iptables, ip6tables and nftables controls are retired
- SELinux moved 1.5.1.x -> 1.4.1.x; new 1.5.x block covers core dump and kernel hardening sysctls
- Sysctl controls 3.3.1-3.3.11 fan out into 3.3.1.1-3.3.1.18 (IPv4) and 3.3.2.1-3.3.2.8 (IPv6), one sysctl per control
- Cron/at file permission controls 4.1.1.x -> 5.1.1.x, SSH 4.2.x -> 5.2.x, sudo 4.3.x -> 5.3.x, PAM 4.4.x -> 5.4.x, user accounts 4.5.x -> 5.5.x
- journald 5.1.2.x -> 6.1.1.x, rsyslog 5.1.1.x -> 6.1.2.x, auditd 5.2.x -> 6.2.x, AIDE 5.3.x -> 6.3.x
- File permission controls 6.1.x -> 7.1.x and user/group controls 6.2.x -> 7.2.x
- amazon2cis_section7 added to defaults, tasks/main.yml, audit vars and the audit bridge template

### Controls retired (37)

- 1.1.1.2 freevxfs, 1.1.1.5 jffs2, 1.1.1.8 usb-storage - absorbed into 1.1.1.7
- 1.5.1.8 SETroubleshoot, 3.2.1 dccp, 3.2.3 rds
- 3.4.1.1, 3.4.1.2, 3.4.3.1-3.4.3.9, 3.4.4.1.1, 3.4.4.2.1-3.4.4.2.6, 3.4.4.3.1-3.4.4.3.6 - iptables/nftables
- 4.4.2.2.6 password maximum sequential characters, 4.5.2.1 default group for root
- 5.1.1.3 journald to rsyslog, 5.1.2.1.1-5.1.2.1.3 systemd-journal-remote - collapsed into 6.1.1.2
- 6.1.14 Audit system file permissions

### Controls added (35)

- 1.1.1.4 overlay kernel module, 1.1.1.7 unused filesystems kernel modules
- 1.5.1 core file size, 1.5.2 fs.protected_hardlinks, 1.5.3 fs.protected_symlinks, 1.5.4 fs.suid_dumpable, 1.5.5 kernel.dmesg_restrict, 1.5.6 kernel.kptr_restrict
- 3.2.1 can kernel module
- 3.3.1.2, 3.3.1.3, 3.3.1.5, 3.3.1.9, 3.3.1.11, 3.3.1.13, 3.3.1.15, 3.3.1.17 - IPv4 sysctls split out from the old combined tasks
- 3.3.2.1-3.3.2.6, 3.3.2.8 - IPv6 sysctls split out from the old combined tasks
- 4.1.4 firewalld active zone target, 4.1.5 loopback traffic, 4.1.6 loopback source address traffic, 4.1.8 drop all traffic
- 5.5.1.2 minimum password days, 5.5.2.2 root only GID 0 account, 5.5.2.3 group root only GID 0 group, 5.5.2.8 accounts without a valid login shell are locked
- 6.1.1.7 journald log file access, 6.2.3.20 audit configuration loaded regardless of errors, 6.3.3 cryptographic protection of audit tools

### Variables

- Added amazon2cis_section7, amazon2cis_fs_sysctl_file, amazon2cis_unused_filesystem_modules
- Added amazon2cis_active_firewall_zone, amazon2cis_firewalld_zone_target, amazon2cis_firewalld_drop_all_traffic
- amazon2cis_firewalld_drop_all_traffic defaults to false - 4.1.8 makes drop the default zone and will block all traffic that is not explicitly allowed, SSH included
- Removed nftables and iptables variables for the retired controls, along with the now unused amazon2cis_pwquality_maxsequence, amazon2cis_journal_* and amazon2cis_rpm_audit_file
- Section 3.3.2 import honours amazon2cis_ipv6_sysctl_force again, matching the pre-split behaviour

### Level tags

- v4.0.0 declares Level 1 - Server and Level 2 - Server only; the inherited level1-workstation and level2-workstation tags are removed
- All 287 controls now carry a single level1-server or level2-server tag matching the benchmark (225 Level 1, 62 Level 2)
- Combined task blocks covering several rule IDs take the lowest level of their rules, so a level1 run no longer skips a Level 1 control
- Goss meta updated to server-only, and every goss level gate now matches its control

### Fixes found during the upgrade

- Repaired five task names where the title sync folded a trailing "# noqa" comment inside the quoted name
- Renamed audit file "cis_1.1.2.5.4 .yml" - the stray space hid it from the content drift check
- Fixed a non-breaking space in defaults/main.yml
- 6.2.3 auditd summary task name corrected from the stale 5.2.3 label
- vars/is_container.yml and molecule converge no longer reference retired rules, and their duplicate keys are removed
- goss.yml gates rewritten for the new layout; the previous file pointed at directories that no longer existed

### Audit repo (AMAZON2-CIS-Audit)

- benchmark_version and BENCHMARK_VER moved to v4.0.0
- Goss files renumbered and regrouped to mirror the remediation task grouping, section_1 through section_7
- 35 new goss files added; 37 retired ones removed
- Coverage 287/287 against the v4.0.0 benchmark, with defaults, audit vars and the bridge template all at 287 toggles

## August 2026 - Section 1.1 mount handler fixes

- Aug26 mount pattern alignment
  - remount_tmp.yml: rhel10cis_tmp_svc -> amazon2cis_tmp_svc, /tmp handler no longer fails
  - Paired "Adding options for <mount>" and "Remounting <mount>" handlers added for /dev/shm, /home, /var, /var/tmp, /var/log, /var/log/audit
  - Mount options accumulated in prelim_mount_point_fs_and_options are now written to fstab; previously computed then discarded

## July 2026 - Section 6 QA pass fixes

- Fixed 6.1.3-6.1.10 file/mode mismatch
- Fixed typos in 6.2.9 audit task names
- Fixed variable bugs in `lockdown_audit.yml.j2`
- Molecule: audit enabled, `dmidecode` added, memory limit added
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
- Workflows: removed `export_badges_public.yml` and `add_repo_issue_to_gh_project.yml`
  (public-mirror-only workflows; do not belong in this private repo)
- LICENSE: fixed copyright casing `Mindpoint` -> `MindPoint`
- README: rebranded Twitter badge to X (`twitter.com` -> `x.com`); fixed grammar
- CONTRIBUTING.rst: fixed duplicate word typo
- `.gitignore`: added `qa_report.md`, `prompt.md`, `test_inv`
- Added `molecule/` with `default` (Docker), `localhost`, and `wsl` scenarios
- Added `vars/is_container.yml` for container-aware runs
- Mount tasks 1.1.2.x.1 relabelled to AUDIT

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

## march26_align (Private-AMAZON2-CIS) based on v3.0.0


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
- Updated to latest versions
- Removed QA report md files
- March26 align merge
- Common files alignment: LICENSE, CONTRIBUTING, workflows, vars merge
- CIS remediation validation: task titles and tags aligned to canonical; rule_3.4.1.2 tag fixed
- audit vars alignment
- updated common files (LICENSE, CONTRIBUTING, workflows)
- removed `ansible.cfg`
- refreshed `collections/requirements.yml`
- defaults/meta updates;
- broad YAML layout/indent/lint fixes across tasks (notably sections 3/4/6) and minor workflow tidy-ups.
- linting
