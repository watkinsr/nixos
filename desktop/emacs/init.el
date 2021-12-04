; Init basic settings
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq visible-bell t)
(setq make-backup-files nil)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(tooltip-mode -1)

; GC
(defun hm/reduce-gc ()
  "Reduce the frequency of garbage collection."
  (setq gc-cons-threshold most-positive-fixnum
        gc-cons-percentage 0.6))

(defun hm/restore-gc ()
  "Restore the frequency of garbage collection."
  (setq gc-cons-threshold 16777216
        gc-cons-percentage 0.1))

;; Make GC more rare during init, while minibuffer is active, and
;; when shutting down. In the latter two cases we try doing the
;; reduction early in the hook.
(hm/reduce-gc)

(add-hook 'minibuffer-setup-hook #'hm/reduce-gc -50)
(add-hook 'kill-emacs-hook #'hm/reduce-gc -50)

;; But make it more regular after startup and after closing minibuffer.
(add-hook 'emacs-startup-hook #'hm/restore-gc)
(add-hook 'minibuffer-exit-hook #'hm/restore-gc)

;; Avoid unnecessary regexp matching while loading .el files.
(defvar hm/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun hm/restore-file-name-handler-alist ()
  "Restores the file-name-handler-alist variable."
  (setq file-name-handler-alist hm/file-name-handler-alist)
  (makunbound 'hm/file-name-handler-alist))
(add-hook 'emacs-startup-hook #'hm/restore-file-name-handler-alist)

; font + theme
(set-face-attribute 'default nil :font "Inconsolata" :height 140)
(load-theme 'doom-solarized-dark-high-contrast t)

; line/column numbers
(column-number-mode)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
		term-mode-hook
		vterm-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

; which key
(which-key-mode)
(setq which-key-idle-delay 0.3)

; company
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)

; ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(ivy-rich-mode 1)

; counsel
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

; evil
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

; flycheck
(global-flycheck-mode)

; doom modeline
(doom-modeline-mode 1)
(setq doom-modeline-height 15)

; hydras
(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

; general
(use-package general
  :config
  (general-create-definer naunau/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (naunau/leader-keys
    "SPC" 'projectile-find-file
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(naunau/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text")
  "ca" 'lsp-execute-code-action
  "ch" 'lsp-rust-analyzer-inlay-hints-mode
  "rn" 'lsp-rename
  "h"  'lsp-describe-thing-at-point
  "gg" 'magit-status)

(general-emacs-define-key 'global
  :prefix "C-c f"
  "g" 'lsp-ivy-global-workspace-symbol
  "s" 'lsp-ivy-workspace-symbol
  "r" 'counsel-rg
  "e" 'counsel-flycheck)

(general-emacs-define-key 'global
  :prefix "C-c g"
  "g" 'magit-status)

(general-emacs-define-key 'normal
  "g[" 'flycheck-previous-error
  "g]" 'flycheck-next-error
  "gr" 'lsp-find-references)

(general-emacs-define-key 'normal
  "C-a" 'avy-goto-char)

; rust
(setq rustic-format-trigger 'on-save)
(push 'rustic-clippy flycheck-checkers)

; lsp
(use-package lsp-mode
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (add-hook 'rustic-mode-hook #'lsp-deferred)
  (add-hook 'prisma-mode-hook #'lsp-deferred))

; helpful
(setq counsel-describe-function-function #'helpful-callable)
(setq counsel-describe-variable-function #'helpful-variable)

; rainbow-delimiters
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

; projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

; direnv
(direnv-mode)

; nix
(use-package nix-mode
  :mode "\\.nix\\'")

; yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

; git gutter
(global-git-gutter-mode +1)

; prisma
(load "/home/pimeys/.emacs.d/prisma-mode.el")
(require 'prisma-mode)

(setq auto-mode-alist
      (cons '("\\.prisma$" . prisma-mode) auto-mode-alist))

; typescript tide
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

(add-hook 'before-save-hook
	  #'(lambda () (when (eq major-mode 'tide-mode)
			 'tide-format-before-save)))

(add-hook 'typescript-mode-hook #'setup-tide-mode)

; Markdown
(add-hook 'markdown-mode-hook #'auto-fill-mode)
(setq-default fill-column 80)

; Shackle
(defun rk/open-compilation-buffer (&optional buffer-or-name shackle-alist shackle-plist)
  "Helper for selecting window for opening *compilation* buffers."
  ;; find existing compilation window left of the current window or left-most window
  (let ((win (or (loop for win = (if win (window-left win) (get-buffer-window))
                       when (or (not (window-left win))
                                (string-prefix-p "*compilation" (buffer-name (window-buffer win))))
                       return win)
                 (get-buffer-window))))
    ;; if the window is dedicated to a non-compilation buffer, use the current one instead
    (when (window-dedicated-p win)
      (let ((buf-name (buffer-name (window-buffer win))))
        (unless (string-prefix-p "*compilation" buf-name)
          (setq win (get-buffer-window)))))
    (set-window-buffer win (get-buffer buffer-or-name))
    (set-frame-selected-window (window-frame win) win)))


(use-package shackle
  :custom
  (shackle-rules '((compilation-mode :custom rk/open-compilation-buffer :select t)
		   ("\\*Apropos\\|Help\\|Occur\\|tide-references\\*" :regexp t :same t :select t :inhibit-window-quit t)
		   ("\\*magit" :regexp t :same t :select t)
		   ("\\*shell.*" :regexp t :same t :select t)
		   ("\\*Cargo.*" :regexp t :other t :select nil)
		   ("*Messages*" :select nil :other t)
		   ("*go-guru-output*" :select t :same t)
		   ("*Proced*" :select t :same t)
		   ("*Buffer List*" :select t :same t)
		   ("\\*Pp Eval" :regexp t :same nil :select t :other t)
		   ("*Messages*" :same nil :other t :select t :inhibit-window-quit t)))
  (shackle-default-rule nil))

(shackle-mode)
