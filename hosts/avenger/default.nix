self: super: {
  nordic-sddm = super.callPackage ./nordic-sddm { };
  pridecat = super.callPackage ./pridecat { };
  keymash = super.callPackage ./keymash { };
}

