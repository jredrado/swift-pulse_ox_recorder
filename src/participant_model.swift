/**
 * \file    participant_model.swift
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
import Combine
import AsyncPulseOx
import SensorRecordingUtils


@MainActor
final class Participant_model: Participant_entry_model
{
    
    override init()
    {
        
        super.init()
        
        load_settings_bundle()
        load_last_particpant_id()
        
    }
    
    
    // MARK: - Public interface
    
    
    /**
     * Verify all the information required is valid before start recoding
     * data
     */
    override func is_configuration_valid() async -> Bool
    {
                
        if await super.is_configuration_valid() == false
        {
            return false
        }

        
        // Check Nonin configuration if enabled
        
        
        if await AS_pulse_ox().can_access_bluetooth() == false
        {
            setup_error = .no_bluetooth_access
            return false
        }
                    
        if is_bluetooth_recording_supported() == false
        {
            return false
        }

        
        cancel_system_event_subscriptions()
        
        return true
        
    }
    
    
    // MARK: - Private state
    
    
    private let settings = Recording_settings()
    
    
    // MARK: - Private interface
    
    
    /**
     * Can we record from selected configuration?
     */
    private func is_bluetooth_recording_supported(
        ) -> Bool
    {
        
        let is_supported : Bool
        
        switch AS_pulse_ox.is_recording_supported()
        {
            case .success():
                is_supported = true
                
            case .failure(let error):
                switch error
                {
                    case .empty_configuration:
                        setup_error = .ble_empty_configuration
                        
                    case .services_not_supported(let services):
                        setup_error = .ble_services_not_supported(services)
                        
                    case .characteristics_not_supported(let characteristics):
                        setup_error = .ble_characteristics_not_supported(
                                characteristics
                            )
                        
                    case .no_characteristics_configured(let services):
                        setup_error = .ble_no_characteristics_configured(
                                services
                            )
                }
                is_supported = false
        }
        
        return is_supported
        
    }
    
}
