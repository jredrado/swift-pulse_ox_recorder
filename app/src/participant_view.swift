/**
 * \file    participant_view.swift
 * \author  Mauricio Villarroel
 * \date    Created: Apr 1, 2022
 * ____________________________________________________________________________
 *
 * Copyright (C) 2022 Mauricio Villarroel. All rights reserved.
 *
 * SPDX-License-Identifer:  GPL-2.0-only
 * ____________________________________________________________________________
 */

import SwiftUI
import AsyncPulseOx
import SensorRecordingUtils


/**
 * The first view the app shows to the user.
 */
struct Participant_view: View
{
    
    var body: some View
    {
        
        Participant_entry_view(
                model: model,
                interface_orientation : $interface_orientation
            )
            {
                Application_recording_view(
                        participant_id        : model.participant_id,
                        interface_orientation : interface_orientation,
                        preview_mode          : .scale_to_fill
                    )
            }
            action_buttons:
            {
                NavigationLink(
                        isActive    : $launch_bluetooth_configuration_screen,
                        destination : { Configure_bluetooth_view() }
                    )
                    {
                        Button("Configure bluetooth", action: open_bluetooth_settings)
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.automatic)
                            .frame(maxWidth: .infinity)
                    }
            }
            .hide_navigation_interface()
        
    }
    
    
    init()
    {
        
        self._model = StateObject( wrappedValue: Participant_model() )

    }
    
    
    // MARK: - Private state
    
    
    @StateObject private var model : Participant_model
    
    @State private var launch_bluetooth_configuration_screen : Bool = false
    
    @State private var interface_orientation = UIDeviceOrientation.unknown
    
    
    // MARK: - Private actions
    
    
    /**
     * Open iOS camera settings app
     */
    private func open_bluetooth_settings()
    {
        
        model.cancel_system_event_subscriptions()
        launch_bluetooth_configuration_screen = true
        
    }
    
}



struct Participant_view_Previews: PreviewProvider
{
    
    
    static var previews: some View
    {
        NavigationView
        {
            Participant_view()
        }
        .navigationViewStyle(.stack)
        .previewInterfaceOrientation(.portrait)

    }
    
}
