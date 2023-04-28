//
//  MyLibraryWidget.swift
//  MyLibraryWidget
//
//  Created by Javier Rodríguez Gómez on 25/12/22.
//

import WidgetKit
import SwiftUI

struct MyLibraryWidget: Widget {
    let kind: String = "MyLibraryWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyLibraryWidgetEntryView(entry: entry)
        }
        // Tamaño de widget soportado
        .supportedFamilies([.systemSmall, .systemMedium])
        // Se muestra título y descripción al elegir el widget a añadir
        .configurationDisplayName("My Library")
        .description("Controla de un vistazo el progreso de tu lectura.")
    }
}

struct MyLibraryWidget2: Widget {
    let kind: String = "MyLibraryWidget2"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyLibraryWidgetEntryView2(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("My Library")
        .description("Comprueba tu lectura semanal.")
    }
}

struct MyLibraryWidget3: Widget {
    let kind: String = "MyLibraryWidget3"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyLibraryWidgetEntryView3(entry: entry)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("My Library")
        .description("Sigue la evolución de tus objetivos.")
    }
}
