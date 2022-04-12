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
    override func is_configuration_valid() async -> Result<Void, Setup_error>
    {

        switch await super.is_configuration_valid()
        {
            case .success():
                break
                
            case .failure(let error):
                return .failure(error)
        }

        
        // Check Nonin configuration if enabled
        
        
        if await AS_pulse_ox().can_access_bluetooth() == false
        {
            return .failure(.no_bluetooth_access)
        }
                    
        switch is_bluetooth_recording_supported()
        {
            case .success():
                break
                
            case .failure(let error):
                return .failure(error)
        }
        
        cancel_system_event_subscriptions()
        
        return .success( () )
        
    }
    
    
    // MARK: - Private state
    
    
    private let settings = Recording_settings()
    
    
    // MARK: - Private interface
    
    
    /**
     * Can we record from selected configuration?
     */
    private func is_bluetooth_recording_supported() -> Result<Void, Setup_error>
    {
        
        let result : Result<Void, Setup_error>
        
        switch AS_pulse_ox.is_recording_supported()
        {
            case .success():
                
                result = .success( () )
                
            case .failure(let error):
                
                switch error
                {
                    case .empty_configuration:
                        result = .failure(.ble_empty_configuration)
                        
                    case .services_not_supported(let services):
                        result = .failure(.ble_services_not_supported(services))
                        
                    case .characteristics_not_supported(let characteristics):
                        result = .failure(.ble_characteristics_not_supported(
                                characteristics
                            ))
                        
                    case .no_characteristics_configured(let services):
                        result = .failure(.ble_no_characteristics_configured(
                                services
                            ))
                }
        }
        
        return result
        
    }
    
}
