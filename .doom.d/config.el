;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

(setq org-directory "~/Dropbox/Documents/org/")

(setq display-line-numbers-type 'relative)

(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

(after! evil-org
  (remove-hook 'org-tab-first-hook #'+org-cycle-only-current-subtree-h))

(setq org-log-done t)

(setq org-link-descriptive nil)
(setq org-hide-emphasis-markers t)

(setq select-enable-clipboard nil)

(defun isolate-kill-ring()
  "Isolate Emacs kill ring from OS X system pasteboard.
This function is only necessary in window system."
  (interactive)
  (setq interprogram-cut-function nil)
  (setq interprogram-paste-function nil))

(defun pasteboard-copy()
  "Copy region to OS X system pasteboard."
  (interactive)
  (shell-command-on-region
   (region-beginning) (region-end) "pbcopy"))

(defun pasteboard-paste()
  "Paste from OS X system pasteboard via `pbpaste' to point."
  (interactive)
  (shell-command-on-region
   (point) (if mark-active (mark) (point)) "pbpaste" nil t))

(defun pasteboard-cut()
  "Cut region and put on OS X system pasteboard."
  (interactive)
  (pasteboard-copy)
  (delete-region (region-beginning) (region-end)))

(if window-system
    (progn
      (isolate-kill-ring)
      ;; bind CMD+C to pasteboard-copy
      (global-set-key (kbd "s-c") 'pasteboard-copy)
      ;; bind CMD+V to pasteboard-paste
      (global-set-key (kbd "s-v") 'pasteboard-paste)
      ;; bind CMD+X to pasteboard-cut
      (global-set-key (kbd "s-x") 'pasteboard-cut)))

(require 'command-log-mode)
(require 'elisp-format)

(projectile-add-known-project "~/Dropbox/Documents/org")

(general-evil-setup)

(defun my-insert-j ()
  (interactive)
  (insert "j"))

(general-imap "j" (general-key-dispatch 'my-insert-j
                    :timeout 0.25
                    "k" 'evil-normal-state))
(general-imap "j" (general-key-dispatch 'my-insert-j
                    :timeout 0.25
                    "j" 'evil-normal-state))

(setq evil-move-cursor-back nil)

(defun kill-all-buffers-not-visible ()
  "Kill all buffers not currently shown in a window somewhere."
  (interactive)
  (dolist (buf  (buffer-list))
    (unless (get-buffer-window buf 'visible) (kill-buffer buf))))
