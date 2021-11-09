/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.opengl.devicecontextgl;

/// \file
/// Definition of the Diligent::IDeviceContextGL interface

import bindbc.diligent.graphics.devicecontext;

struct ISwapChainGL;

// {3464FDF1-C548-4935-96C3-B454C9DF6F6A}
static const INTERFACE_ID IID_DeviceContextGL =
    INTERFACE_ID(0x3464fdf1, 0xc548, 0x4935, [0x96, 0xc3, 0xb4, 0x54, 0xc9, 0xdf, 0x6f, 0x6a]);

/// Exposes OpenGL-specific functionality of a device context.
struct IDeviceContextGLMethods
{
    /// Attaches to the active GL context in the thread.

    /// If an application uses multiple GL contexts, this method must be called before any
    /// other command to let the engine update active context every time when control flow
    /// is passed over from the main application
    ///
    /// \return false if there is no active GL context, and true otherwise
    bool* UpdateCurrentGLContext(IDeviceContextGL*);

    /// Sets the swap in the device context. The swap chain is used by the device context
    /// to obtain the default FBO handle.
    void* SetSwapChain(IDeviceContextGL*, ISwapChainGL* pSwapChain);
}

struct IDeviceContextGLVtbl { IDeviceContextGLMethods DeviceContextGL; }
struct IDeviceContextGL { IDeviceContextGLVtbl* pVtbl; }

//#    define IDeviceContextGL_UpdateCurrentGLContext(This) CALL_IFACE_METHOD(DeviceContextGL, UpdateCurrentGLContext, This)
//#    define IDeviceContextGL_SetSwapChain(This, ...)      CALL_IFACE_METHOD(DeviceContextGL, SetSwapChain,           This, __VA_ARGS__)

bool* IDeviceContextGL_UpdateCurrentGLContext(IDeviceContextGL* context) {
    return context.pVtbl.DeviceContextGL.UpdateCurrentGLContext(context);
}

void* IDeviceContextGL_SetSwapChain(IDeviceContextGL* context, ISwapChainGL* pSwapChain) {
    return context.pVtbl.DeviceContextGL.SetSwapChain(context, pSwapChain);
}
