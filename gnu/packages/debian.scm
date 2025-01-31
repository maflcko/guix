;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2018, 2020-2023 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2018, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2020 Marius Bakke <marius@gnu.org>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages debian)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages crypto)
  #:use-module (gnu packages dbm)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages man)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages wget)
  #:use-module (srfi srfi-26))

(define-public debian-archive-keyring
  (package
    (name "debian-archive-keyring")
    (version "2023.4")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://salsa.debian.org/release-team/debian-archive-keyring.git")
              (commit version)))
        (file-name (git-file-name name version))
        (sha256
         (base32 "0gn24dgzpg9zwq2hywkac4ljr5lrh7smyqxm21k2bivl0bhc4ca6"))))
    (build-system gnu-build-system)
    (arguments
     '(#:test-target "verify-results"
       #:parallel-build? #f ; has race conditions
       #:phases
       (modify-phases %standard-phases
         (delete 'configure) ; no configure script
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (apt (string-append out "/etc/apt/trusted.gpg.d/"))
                    (key (string-append out "/share/keyrings/")))
               (install-file "keyrings/debian-archive-keyring.gpg" key)
               (install-file "keyrings/debian-archive-removed-keys.gpg" key)
               (for-each (lambda (file)
                           (install-file file apt))
                         (find-files "trusted.gpg" "\\.gpg$"))))))))
    (native-inputs
     (list gnupg jetring))
    (home-page "https://packages.qa.debian.org/d/debian-archive-keyring.html")
    (synopsis "GnuPG archive keys of the Debian archive")
    (description
     "The Debian project digitally signs its Release files.  This package
contains the archive keys used for that.")
    (license (list license:public-domain ; the keys
                   license:gpl2+)))) ; see debian/copyright

(define-public debian-ports-archive-keyring
  (package
    (name "debian-ports-archive-keyring")
    (version "2023.02.01")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "mirror://debian/pool/main/d"
                            "/debian-ports-archive-keyring"
                            "/debian-ports-archive-keyring_" version ".tar.xz"))
        (sha256
         (base32
          "1xq7i6plgfbf4drqdmmk1yija48x11jmhnk2av3cajn2cdhkw73s"))))
    (build-system gnu-build-system)
    (arguments
     '(#:tests? #f              ; No test suite.
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)    ; No configure script.
         (replace 'build
           (lambda _
             ;; gpg options derived from the debian/rules file.
             (let ((gpg-options (list "--no-options" "--no-default-keyring"
                                      "--no-auto-check-trustdb" "--no-keyring"
                                      "--import-options" "import-export"
                                      "--import")))
               (with-output-to-file "debian-ports-archive-keyring.gpg"
                 (lambda _
                   (apply invoke "gpg"
                          (append gpg-options (find-files "active-keys")))))
               (with-output-to-file "debian-ports-archive-keyring-removed.gpg"
                 (lambda _
                   (apply invoke "gpg"
                          (append gpg-options (find-files "removed-keys")))))
               (mkdir "trusted.gpg")
               (for-each
                 (lambda (key)
                   (with-output-to-file
                     (string-append "trusted.gpg/" (basename key ".key") ".gpg")
                     (lambda _
                       (apply invoke "gpg" (append gpg-options (list key))))))
                 (find-files "active-keys")))))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (apt (string-append out "/etc/apt/trusted.gpg.d/"))
                    (key (string-append out "/share/keyrings/")))
               (install-file "debian-ports-archive-keyring.gpg" key)
               (install-file "debian-ports-archive-keyring-removed.gpg" key)
               (for-each (lambda (file)
                           (install-file file apt))
                         (find-files "trusted.gpg" "\\.gpg$"))))))))
    (native-inputs
     (list gnupg))
    (home-page "https://tracker.debian.org/pkg/debian-ports-archive-keyring")
    (synopsis "GnuPG archive keys of the Debian ports archive")
    (description
     "The Debian ports-archive digitally signs its Release files.  This package
contains the archive keys used for that.")
    ;; "The keys in the keyrings don't fall under any copyright."
    (license license:public-domain)))

(define-public ubuntu-keyring
  (package
    (name "ubuntu-keyring")
    (version "2021.03.26")
    (source
      (origin
        (method url-fetch)
        (uri (string-append "https://launchpad.net/ubuntu/+archive/primary/"
                            "+files/" name "_" version ".tar.gz"))
        (sha256
         (base32
          "1ccvwh4s51viyhcg8gh189jmvbrhc5wv1bbp4minz3200rffsbj9"))))
    (build-system trivial-build-system)
    (arguments
     `(#:modules ((guix build utils))
       #:builder (begin
                   (use-modules (guix build utils))
                   (let* ((out (assoc-ref %outputs "out"))
                          (apt (string-append out "/etc/apt/trusted.gpg.d/"))
                          (key (string-append out "/share/keyrings/")))
                     (setenv "PATH" (string-append
                                      (assoc-ref %build-inputs "gzip") "/bin:"
                                      (assoc-ref %build-inputs "tar") "/bin"))
                     (invoke "tar" "xvf" (assoc-ref %build-inputs "source"))
                     (for-each (lambda (file)
                                 (install-file file apt))
                               (find-files "." "ubuntu-[^am].*\\.gpg$"))
                     (for-each (lambda (file)
                                 (install-file file key))
                               (find-files "." "ubuntu-[am].*\\.gpg$")))
                   #t)))
    (native-inputs
     (list tar gzip))
    (home-page "https://launchpad.net/ubuntu/+source/ubuntu-keyring")
    (synopsis "GnuPG keys of the Ubuntu archive")
    (description
     "The Ubuntu project digitally signs its Release files.  This package
contains the archive keys used for that.")
    (license (list license:public-domain ; the keys
                   license:gpl2+)))) ; see debian/copyright

(define-public debootstrap
  (package
    (name "debootstrap")
    (version "1.0.132")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://salsa.debian.org/installer-team/debootstrap.git")
              (commit version)))
        (file-name (git-file-name name version))
        (sha256
         (base32 "1l6mc3i2wqfhmhj85x9qiiqchqp9br6gg54hv1xs08h8xndmfchf"))))
    (build-system gnu-build-system)
    (arguments
     (list
       #:phases
       #~(modify-phases %standard-phases
           (delete 'configure)
           (add-after 'unpack 'patch-source
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let ((debian #$(this-package-input "debian-archive-keyring"))
                     (ubuntu #$(this-package-input "ubuntu-keyring")))
                 (substitute* "Makefile"
                   (("/usr") "")
                   (("-o root -g root") "")
                   (("chown root.*") "\n"))
                 (substitute* '("scripts/etch"
                                "scripts/potato"
                                "scripts/sarge"
                                "scripts/sid"
                                "scripts/woody"
                                "scripts/woody.buildd")
                   (("/usr") debian))
                 (substitute* "scripts/gutsy"
                   (("/usr") ubuntu))
                 (substitute* "debootstrap"
                   (("=/usr") (string-append "=" #$output))
                   (("/usr/bin/dpkg") (search-input-file inputs "/bin/dpkg")))
                 ;; Include the keyring locations by default.
                 (substitute* (find-files "scripts")
                   (("keyring.*(debian-archive-keyring.gpg)"_ keyring)
                    (string-append "keyring " debian "/share/keyrings/" keyring))
                   (("keyring.*(ubuntu-archive-keyring.gpg)" _ keyring)
                    (string-append "keyring " ubuntu "/share/keyrings/" keyring)))
                 ;; Ensure PATH works both in guix and within the debian chroot
                 ;; workaround for: https://bugs.debian.org/929889
                 (substitute* "functions"
                   (("PATH=/sbin:/usr/sbin:/bin:/usr/bin")
                    "PATH=$PATH:/sbin:/usr/sbin:/bin:/usr/bin"))
                 (substitute* (find-files "scripts")
                   (("/usr/share/zoneinfo")
                    (search-input-directory inputs "/share/zoneinfo"))))))
           (add-after 'install 'install-man-file
             (lambda* (#:key outputs #:allow-other-keys)
               (install-file "debootstrap.8"
                             (string-append #$output "/share/man/man8"))))
           (add-after 'install 'wrap-executable
             (lambda* (#:key outputs #:allow-other-keys)
               (let ((debootstrap (string-append #$output "/sbin/debootstrap"))
                     (path        (getenv "PATH")))
                 (wrap-program debootstrap
                               `("PATH" ":" prefix (,path)))))))
         #:make-flags #~(list (string-append "DESTDIR=" #$output))
         #:tests? #f))  ; no tests
    (inputs
     (list debian-archive-keyring
           ubuntu-keyring
           bash-minimal
           dpkg
           tzdata

           ;; Called at run-time from various places, needs to be in PATH.
           gnupg
           wget))
    (native-inputs
     (list perl))
    (home-page "https://tracker.debian.org/pkg/debootstrap")
    (synopsis "Bootstrap a basic Debian system")
    (description "Debootstrap is used to create a Debian base system from
scratch, without requiring the availability of @code{dpkg} or @code{apt}.
It does this by downloading .deb files from a mirror site, and carefully
unpacking them into a directory which can eventually be chrooted into.")
    (license license:gpl2)))

(define-public debianutils
  (package
    (name "debianutils")
    (version "5.7-0.4")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://salsa.debian.org/debian/debianutils.git")
                    (commit (string-append "debian/" version))))
              (file-name (git-file-name "debianutils" version))
              (sha256
               (base32
                "0hw407fm5ylsf28b0vrwz7rm2r2rsgfwzajbkbn6n2b6kqhdjyy9"))))
    (build-system gnu-build-system)
    (native-inputs
     (list autoconf automake gettext-minimal po4a))
    (home-page "https://packages.debian.org/unstable/debianutils")
    (synopsis "Miscellaneous shell utilities")
    (description
     "This package provides a number of utilities which are mostly for use
in installation scripts of Debian packages.  The programs included are
@command{add-shell}, @command{installkernel}, @command{ischroot},
@command{remove-shell}, @command{run-parts}, @command{savelog},
@command{tempfile}, and @command{which}.")
    (license (list license:gpl2+
                   ;; The 'savelog' program is distributed under a
                   ;; GPL-compatible copyleft license.
                   (license:fsf-free "file://debian/copyright"
                                     "The SMAIL General Public License, see
debian/copyright for more information.")))))

(define-public apt-mirror
  (let ((commit "e664486a5d8947c2579e16dd793d762ea3de4202")
        (revision "1"))
    (package
      (name "apt-mirror")
      (version (git-version "0.5.4" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/apt-mirror/apt-mirror/")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0qj6b7gldwcqyfs2kp6amya3ja7s4vrljs08y4zadryfzxf35nqq"))))
      (build-system gnu-build-system)
      (outputs '("out"))
      (arguments
       `(#:tests? #f
         ;; sysconfdir is not PREFIXed in the makefile but DESTDIR is
         ;; honored correctly; we therefore use DESTDIR for our
         ;; needs. A more correct fix would involve patching.
         #:make-flags (list (string-append "DESTDIR=" (assoc-ref %outputs "out"))
                            "PREFIX=/")
         #:phases (modify-phases %standard-phases (delete 'configure))))
      (inputs
       (list wget perl))
      (home-page "https://apt-mirror.github.io/")
      (synopsis "Script for mirroring a Debian repository")
      (description
       "apt-mirror is a small tool that provides the ability to selectively
mirror @acronym{APT, advanced package tool} sources, including GNU/Linux
distributions such as Debian and Trisquel.")
      (license license:gpl2))))

(define-public dpkg
  (package
    (name "dpkg")
    (version "1.22.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://git.dpkg.org/git/dpkg/dpkg")
               (commit version)))
        (file-name (git-file-name name version))
        (sha256
         (base32 "1s6dzcczmpkr9pla25idymfdjz10gck0kphpp0vqbp92vmfskipg"))))
    (build-system gnu-build-system)
    (arguments
     (list #:modules
           `((srfi srfi-71)
             ,@%gnu-build-system-modules)
           #:phases
           #~(modify-phases %standard-phases
               (add-before 'bootstrap 'patch-version
                 (lambda _
                   (patch-shebang "build-aux/get-version")
                   (with-output-to-file ".dist-version"
                     (lambda () (display #$version)))))
               (add-after 'unpack 'set-perl-libdir
                 (lambda _
                   (let* ((perl #$(this-package-input "perl"))
                          (_ perl-version (package-name->name+version perl)))
                     (setenv "PERL_LIBDIR"
                             (string-append #$output
                                            "/lib/perl5/site_perl/"
                                            perl-version)))))
               (add-after 'install 'wrap-scripts
                 (lambda _
                   (with-directory-excursion (string-append #$output "/bin")
                     (for-each
                      (lambda (file)
                        (wrap-script file
                          ;; Make sure all perl scripts in "bin" find the
                          ;; required Perl modules at runtime.
                          `("PERL5LIB" ":" prefix
                            (,(string-append #$output
                                             "/lib/perl5/site_perl")
                             ,(getenv "PERL5LIB")))
                          ;; DPKG perl modules expect dpkg to be installed.
                          ;; Work around it by adding dpkg to the script's path.
                          `("PATH" ":" prefix (,(string-append #$output
                                                               "/bin")))))
                      (list "dpkg-architecture"
                            "dpkg-buildapi"
                            "dpkg-buildflags"
                            "dpkg-buildpackage"
                            "dpkg-checkbuilddeps"
                            "dpkg-distaddfile"
                            "dpkg-genbuildinfo"
                            "dpkg-genchanges"
                            "dpkg-gencontrol"
                            "dpkg-gensymbols"
                            "dpkg-mergechangelogs"
                            "dpkg-name"
                            "dpkg-parsechangelog"
                            "dpkg-scanpackages"
                            "dpkg-scansources"
                            "dpkg-shlibdeps"
                            "dpkg-source"
                            "dpkg-vendor"))))))))
    (native-inputs
     (list autoconf
           automake
           gettext-minimal
           gnupg                        ; to run t/Dpkg_OpenPGP.t
           libtool
           pkg-config
           perl-io-string))
    (inputs
     (list bzip2
           guile-3.0                    ; for wrap-script
           libmd
           ncurses
           perl
           xz
           zlib))
    (home-page "https://wiki.debian.org/Teams/Dpkg")
    (synopsis "Debian package management system")
    (description "This package provides the low-level infrastructure for
handling the installation and removal of Debian software packages.")
    (license license:gpl2+)))

(define-public pbuilder
  (package
    (name "pbuilder")
    (version "0.231")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://salsa.debian.org/pbuilder-team/pbuilder.git/")
               (commit version)))
        (file-name (git-file-name name version))
        (sha256
         (base32 "0z6f1fgcrkfql9ayc3d0nxra2y6cn91xd5lvr0hd8gdlp9xdvxbc"))))
    (build-system gnu-build-system)
    (arguments
     (list
       #:modules `((guix build gnu-build-system)
                   (guix build utils)
                   (srfi srfi-26))
       #:phases
       #~(modify-phases %standard-phases
           (delete 'configure)          ; no configure script
           (add-after 'unpack 'patch-source
             (lambda* (#:key inputs outputs #:allow-other-keys)

               ;; Documentation requires tldp-one-page.xsl
               (substitute* "Makefile"
                 ((".*-C Documentation.*") ""))

               ;; Don't create #$output/var/cache/pbuilder/...
               (substitute* '("Makefile"
                              "pbuildd/Makefile")
                 ((".*/var/cache/pbuilder.*") ""))

               ;; Find the correct fallback location.
               (substitute* '("pbuilder-checkparams"
                              "pbuilder-loadconfig"
                              "pbuilder-satisfydepends-apt"
                              "pbuilder-satisfydepends-aptitude"
                              "pbuilder-satisfydepends-classic"
                              "t/test_pbuilder-satisfydepends-classic")
                 (("\\$PBUILDER_ROOT(/usr)?") #$output))

               ;; Some hardcoded paths
               (substitute* '("debuild-pbuilder"
                              "pbuilder"
                              "pbuilder-buildpackage"
                              "pbuilderrc"
                              "pdebuild"
                              "pdebuild-checkparams"
                              "pdebuild-internal")
                 (("/usr/lib/pbuilder")
                  (string-append #$output "/lib/pbuilder")))
               (substitute* "pbuildd/buildd-config.sh"
                 (("/usr/share/doc/pbuilder")
                  (string-append #$output "/share/doc/pbuilder")))
               (substitute* "pbuilder-unshare-wrapper"
                 (("/(s)?bin/ifconfig") "ifconfig")
                 (("/(s)?bin/ip") (search-input-file inputs "/sbin/ip")))
               (substitute* "Documentation/Makefile"
                 (("/usr") ""))

               ;; Ensure PATH works both in Guix and within the Debian chroot.
               (substitute* "pbuilderrc"
                 (("PATH=\"/usr/sbin:/usr/bin:/sbin:/bin")
                  "PATH=\"$PATH:/usr/sbin:/usr/bin:/sbin:/bin"))))
           (add-after 'install 'create-etc-pbuilderrc
             (lambda* (#:key outputs #:allow-other-keys)
               (with-output-to-file (string-append #$output "/etc/pbuilderrc")
                 (lambda ()
                   (format #t "# A couple of presets to make this work more smoothly.~@
                           MIRRORSITE=\"http://deb.debian.org/debian\"~@
                           if [ -r /run/setuid-programs/sudo ]; then~@
                               PBUILDERROOTCMD=\"/run/setuid-programs/sudo -E\"~@
                           fi~@
                           PBUILDERSATISFYDEPENDSCMD=\"~a/lib/pbuilder/pbuilder-satisfydepends-apt\"~%"
                           #$output)))))
           (add-after 'install 'install-manpages
             (lambda* (#:key outputs #:allow-other-keys)
               (let ((man (string-append #$output "/share/man/")))
                 (install-file "debuild-pbuilder.1" (string-append man "man1"))
                 (install-file "pdebuild.1" (string-append man "man1"))
                 (install-file "pbuilder.8" (string-append man "man8"))
                 (install-file "pbuilderrc.5" (string-append man "man5")))))
           (add-after 'install 'wrap-programs
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (for-each
                 (lambda (file)
                   (wrap-script file
                    `("PATH" ":" prefix
                      ,(map (compose dirname (cut search-input-file inputs <>))
                            (list "/bin/cut"
                                  "/bin/dpkg"
                                  "/bin/grep"
                                  "/bin/perl"
                                  "/bin/sed"
                                  "/bin/which"
                                  "/sbin/debootstrap")))))
                 (cons*
                   (string-append #$output "/bin/pdebuild")
                   (string-append #$output "/sbin/pbuilder")
                   (find-files (string-append #$output "/lib/pbuilder"))))))
           ;; Move the 'check phase to after 'install.
           (delete 'check)
           (add-after 'validate-runpath 'check
             (assoc-ref %standard-phases 'check)))
         #:make-flags
         ;; No PREFIX, use DESTDIR instead.
         #~(list (string-append "DESTDIR=" #$output)
                 (string-append "SYSCONFDIR=" #$output "/etc")
                 (string-append "BINDIR=" #$output "/bin")
                 (string-append "PKGLIBDIR=" #$output "/lib/pbuilder")
                 (string-append "SBINDIR=" #$output "/sbin")
                 (string-append "PKGDATADIR=" #$output "/share/pbuilder")
                 (string-append "EXAMPLEDIR=" #$output "/share/doc/pbuilder/examples")
                 "PBUILDDDIR=/share/doc/pbuilder/examples/pbuildd/")))
    (inputs
     (list dpkg
           debootstrap
           grep
           guile-3.0            ; for wrap-script
           iproute
           perl
           which))
    (native-inputs
     (list man-db
           util-linux))
    (home-page "https://pbuilder-team.pages.debian.net/pbuilder/")
    (synopsis "Personal package builder for Debian packages")
    (description
     "@code{pbuilder} is a personal package builder for Debian packages.
@itemize
@item@code{pbuilder} constructs a chroot system, and builds a package inside the
chroot.  It is an ideal system to use to check that a package has correct
build-dependencies.  It uses @code{apt} extensively, and a local mirror, or a
fast connection to a Debian mirror is ideal, but not necessary.
@item@code{pbuilder create} uses debootstrap to create a chroot image.
@item@code{pbuilder update} updates the image to the current state of
testing/unstable/whatever.
@item@code{pbuilder build} takes a @code{*.dsc} file and builds a binary in the
chroot image.
@item@code{pdebuild} is a wrapper for Debian Developers, to allow running
@code{pbuilder} just like @code{debuild}, as a normal user.
@end itemize")
    (license license:gpl2+)))

(define-public reprepro
  (package
    (name "reprepro")
    (version "5.3.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://salsa.debian.org/brlink/reprepro.git/")
               (commit (string-append name "-" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32
          "1kn7m5rxay6q2c4vgjgm4407xx2r46skkkb6rn33m6dqk1xfkqnh"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ; testtool not found
       #:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda* (#:key tests? #:allow-other-keys)
             (if tests?
               (with-directory-excursion "tests"
                 (invoke (which "sh") "test.sh"))
               #t)))
         (add-after 'install 'install-completions
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out  (assoc-ref outputs "out"))
                    (bash (string-append out "/etc/bash_completion.d/"))
                    (zsh  (string-append out "/share/zsh/site-fucnctions/")))
               (mkdir-p bash)
               (mkdir-p zsh)
               (copy-file "docs/reprepro.bash_completion"
                          (string-append bash "reprepro"))
               (copy-file "docs/reprepro.zsh_completion"
                          (string-append zsh "_reprepro"))
               #t))))))
    (inputs
     (list bdb
           bzip2
           gpgme
           libarchive
           xz
           zlib))
    (native-inputs
     (list autoconf automake))
    (home-page "https://salsa.debian.org/brlink/reprepro")
    (synopsis "Debian package repository producer")
    (description "Reprepro is a tool to manage a repository of Debian packages
(@code{.deb}, @code{.udeb}, @code{.dsc}, ...).  It stores files either being
injected manually or downloaded from some other repository (partially) mirrored
into one pool/ hierarchy.  Managed packages and files are stored in a Berkeley
DB, so no database server is needed.  Checking signatures of mirrored
repositories and creating signatures of the generated Package indices is
supported.")
    (license license:gpl2)))
