using Gtk;

namespace UserIndicatorRedux {
    public class Plugin : Budgie.Plugin, Peas.ExtensionBase {
        public Budgie.Applet get_panel_widget (string uuid) {
            return new UserIndicatorRedux.Applet (uuid);
        }
    }

    public class Applet : Budgie.Applet {
        public string uuid { get; set; }

        construct {
            var button = new Button.from_icon_name ("system-shutdown-symbolic", MENU);
            button.get_style_context ().add_class ("flat");

            add (button);
            show_all ();
        }

        public Applet (string uuid) {
            Object (uuid: uuid);
        }
    }
}

[ModuleInit]
public void peas_register_types (TypeModule module) {
    var objmodule = module as Peas.ObjectModule;
    objmodule.register_extension_type (typeof (Budgie.Plugin), typeof (UserIndicatorRedux.Plugin));
}