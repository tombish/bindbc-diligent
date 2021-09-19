/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Graphics/GraphicsEngine/interface/DeviceObject.h
 *  The original licence follows this statement
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
 
module bindbc.diligent.graphics.deviceobject;

public import bindbc.diligent.primitives.object;
public import bindbc.diligent.graphics.graphicstypes;

// {5B4CCA0B-5075-4230-9759-F48769EE5502}
static const INTERFACE_ID IID_DeviceObject = 
    INTERFACE_ID(0x5b4cca0b, 0x5075, 0x4230, [0x97, 0x59, 0xf4, 0x87, 0x69, 0xee, 0x55, 0x2]);


struct IDeviceObjectMethods
{
     /// Returns the object description
    DeviceObjectAttribs** GetDesc(IDeviceObject*) const;


    /// Returns unique identifier assigned to an object

    /// \remarks Unique identifiers can be used to reliably check if two objects are identical.
    ///          Note that the engine resuses memory reclaimed after an object has been released.
    ///          For example, if a texture object is released and then another texture is created,
    ///          the engine may return the same pointer, so pointer-to-pointer comparisons are not
    ///          reliable. Unique identifiers, on the other hand, are guaranteed to be, well, unique.
    ///
    ///          Unique identifiers are object-specifics, so, for instance, buffer identifiers
    ///          are not comparable to texture identifiers.
    ///
    ///          Unique identifiers are only meaningful within one session. After an application
    ///          restarts, all identifiers become invalid.
    ///
    ///          Valid identifiers are always positive values. Zero and negative values can never be
    ///          assigned to an object and are always guaranteed to be invalid.
    int* GetUniqueID(IDeviceObject*);


    /// Stores a pointer to the user-provided data object, which
    /// may later be retrieved through GetUserData().
    ///
    /// \param [in] pUserData - Pointer to the user data object to store.
    ///
    /// \note   The method is not thread-safe and an application
    ///         must externally synchronize the access.
    ///
    ///         The method keeps strong reference to the user data object.
    ///         If an application needs to release the object, it
    ///         should call SetUserData(nullptr);
    void* SetUserData(in IDeviceObject, IObject* pUserData);


    /// Returns a pointer to the user data object previously
    /// set with SetUserData() method.
    ///
    /// \return     The pointer to the user data object.
    /// 
    /// \remarks    The method does *NOT* call AddRef()
    ///             for the object being returned.
    IObject** GetUserData(IDeviceObject*);
}

struct IDeviceObjectVtbl { IDeviceObjectMethods DeviceObject; }
struct IDeviceObject { IDeviceObjectVtbl* pVtbl; }

//#include "../../../Primitives/interface/UndefInterfaceHelperMacros.h"

//#    define IDeviceObject_GetDesc(This)          CALL_IFACE_METHOD(DeviceObject, GetDesc,     This)
//#    define IDeviceObject_GetUniqueID(This)      CALL_IFACE_METHOD(DeviceObject, GetUniqueID, This)
//#    define IDeviceObject_SetUserData(This, ...) CALL_IFACE_METHOD(DeviceObject, SetUserData, This, __VA_ARGS__)
//#    define IDeviceObject_GetUserData(This)      CALL_IFACE_METHOD(DeviceObject, GetUserData, This)

DeviceObjectAttribs** IDeviceObject_GetDesc(IDeviceObject* object) {
    return object.pVtbl.DeviceObject.GetDesc(object);
}
int* IDeviceObject_GetUniqueID(IDeviceObject* object) {
    return object.pVtbl.DeviceObject.GetUniqueID(object);
}
void* IDeviceObject_SetUserData(IDeviceObject* object, IObject* pUserData) {
    object.pVtbl.DeviceObject.SetUserData(object, pUserData);
}
IObject** IDeviceObject_GetUserData(IDeviceObject* object) {
    return object.pVtbl.DeviceObject.GetUserData(object);
}