;;; -*- lexical-binding: t -*-
;;; -*- no-byte-compile: t -*-

(use-package counsel)       ; greedy load, to enable mappings
(use-package evil-surround)
(setq evil-mc-key-map nil)  ; don't pollute keys
(after! pythonic
  (setq python-shell-virtualenv-root "/usr")  ; it will otherwise look for .local/bin which may contain ipython2
)

(after! evil
  (global-evil-surround-mode 1)
  (evil-ex-define-cmd "vsp" 'evil-window-vsplit)
)

(after! ivy
  ;(defun switch-to-buffer-new-window (buffer-or-name side)
  ;  "Switch to BUFFER-OR-NAME in a new window, based on SIDE."
  ;  (select-window (split-window nil nil side))
  ;  (balance-windows)
  ;  (switch-to-buffer buffer-or-name)
  ;  )

  ;(defun find-file-new-window (filename side)
  ;  (switch-to-buffer-new-window (find-file-noselect filename) side))

  ;(defmacro my/new-window-context (code side)
  ;  `(letf (
  ;                                      ;((symbol-function 'find-file-other-window) (lambda (a) (find-file-new-window a ,side)))
  ;          ((symbol-function 'find-file) (lambda (a) (find-file-new-window a ,side)))
  ;                                      ;((symbol-function 'switch-to-buffer-other-window) (lambda (a) (switch-to-buffer-new-window a ,side)))
  ;          )
  ;     ,code
  ;     )
  ;  )

  (defun my/ivy-exit-new-window (side)
    ;(cl-flet ((current-act (ivy--get-action ivy-last)))
    ;  (ivy-exit-with-action
    ;    (lambda (x)
    ;      (message "WITH %s" x)
    ;      (select-window (split-window nil nil side))
    ;      (balance-windows)
    ;      (current-act x)
    ;    ))
    ;)

    (let ((current-act (ivy--get-action ivy-last)))
      (pcase current-act
        ; TODO handle special cases
        (-
         (ivy-exit-with-action
          (lambda (x)
            (setf
             (ivy-state-window ivy-last)
             (select-window (split-window nil nil side))
            )      ; so that with-ivy-window (used a lot inside predefined actions) will use the new window
            (balance-windows)
            (funcall current-act x)
            )))
        )
      )
    )

    (define-key ivy-minibuffer-map (kbd "C-v") (lambda! (my/ivy-exit-new-window 'right)))
	(define-key ivy-minibuffer-map (kbd "C-s") (lambda! (my/ivy-exit-new-window 'below)))
	(define-key ivy-minibuffer-map (kbd "C-x") (lambda! (my/ivy-exit-new-window 'below)))
)

(setq doom-font (font-spec :family "Monospace" :size 20))
(set-face-attribute 'line-number-current-line nil :inherit '(hl-line default))
;; https://github.com/hlissner/emacs-doom-themes/blob/master/doom-themes-common.el#L67-L70

(load! +bindings)