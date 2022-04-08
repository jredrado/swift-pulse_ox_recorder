/**
 * \file    main_app.swift
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


@main
struct Main_app: App
{
    var body: some Scene
    {
        WindowGroup
        {
            NavigationView
            {
                Participant_view()
            }
            .navigationViewStyle(.stack)
        }
    }
}
