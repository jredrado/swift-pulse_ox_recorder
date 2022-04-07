/**
 * \file    application_recording_view.swift
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
import SensorRecordingUtils
import AsyncPulseOx


struct Application_recording_view: View
{
    
    var body: some View
    {
        
        GeometryReader
        {
            geo in
            
            if let manager = session.all_sensors.first as? AsyncPulseOx.Recording_manager
            {
                Recording_session_view(
                        model          : session,
                        sensor_content : Pulse_ox_view(manager)
                    )
            }
            else
            {
                Recording_session_view(model: session)
            }
        }
        .hide_navigation_interface()
        .ignoresSafeArea()
        
    }
    
    
    /**
     * View initialiser
     */
    public init(
            participant_id        : String ,
            interface_orientation : UIDeviceOrientation,
            preview_mode          : Device.Content_mode,
            pulse_ox_manager      : AsyncPulseOx.Recording_manager? = nil
        )
    {
        _session  = StateObject(
                wrappedValue: Application_recording_model(
                    participant_id        : participant_id,
                    interface_orientation : interface_orientation,
                    preview_mode          : preview_mode,
                    pulse_ox_manager      : pulse_ox_manager
                )
            )
    }
    
    
    // MARK: - Private state
    
    
    @StateObject private var session: Application_recording_model
    
}


struct Main_capture_view_Previews: PreviewProvider
{
    
    static var previews: some View
    {
        
        
        Group
        {
            NavigationView
            {
                Application_recording_view(
                    participant_id        : "PT_01",
                    interface_orientation : .landscapeLeft,
                    preview_mode          : .scale_to_fill
                )
            }
            
            
            NavigationView
            {
                Application_recording_view(
                    participant_id        : "PT_01",
                    interface_orientation : .landscapeLeft,
                    preview_mode          : .scale_to_fill,
                    pulse_ox_manager      : AsyncPulseOx.Recording_manager(
                                                orientation  : .landscapeLeft,
                                                preview_mode : .scale_to_fill,
                                                device_state : .disconnected,
                                                connection_timeout: 0
                                            )
                    )
            }

        }
        .navigationViewStyle(.stack)
        .previewInterfaceOrientation(.landscapeRight)
            
        
        
        Group
        {
            NavigationView
            {
                Application_recording_view(
                    participant_id        : "PT_01",
                    interface_orientation : .landscapeRight,
                    preview_mode          : .scale_to_fill,
                    pulse_ox_manager      : AsyncPulseOx.Recording_manager(
                                                orientation  : .landscapeLeft,
                                                preview_mode : .scale_to_fill,
                                                device_state : .disconnected,
                                                connection_timeout: 0
                                            )
                )
            }
        }
        .navigationViewStyle(.stack)
        .previewInterfaceOrientation(.landscapeLeft)
        
            
        Group
        {
            NavigationView
            {
                Application_recording_view(
                    participant_id        : "PT_02",
                    interface_orientation : .portrait,
                    preview_mode          : .scale_to_fill
                )
            }
            
            
            NavigationView
            {
                Application_recording_view(
                    participant_id        : "PT_02",
                    interface_orientation : .portrait,
                    preview_mode          : .scale_to_fill,
                    pulse_ox_manager      : AsyncPulseOx.Recording_manager(
                                                orientation  : .landscapeLeft,
                                                preview_mode : .scale_to_fill,
                                                device_state : .disconnected,
                                                connection_timeout: 0
                                            )
                    )
            }
        }
        .navigationViewStyle(.stack)
        .previewInterfaceOrientation(.portrait)
        
    }
    
}
